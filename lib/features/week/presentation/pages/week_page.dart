import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_bottom_sheet_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_empty_state.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_error_state.dart';
import 'package:smartfit/features/shared/presentation/layouts/app_page_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_icon_capsule_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_primary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/rest_day_card.dart';
import 'package:smartfit/features/shared/presentation/widgets/training_day_card.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/week/presentation/controllers/week_controller.dart';

class WeekPage extends ConsumerStatefulWidget {
  const WeekPage({super.key});

  static const routeName = 'week';
  static const routePath = '/week';

  @override
  ConsumerState<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends ConsumerState<WeekPage> {
  bool isOrganizeMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekAsync = ref.watch(weekControllerProvider);

    return AppPageScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Week', style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Only created days live here', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This shell already respects the product rule: no fake weekdays, no empty placeholders mixed into the weekly structure.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        AppIconCapsuleButton(
          icon: isOrganizeMode ? Icons.done_rounded : Icons.swap_vert_rounded,
          label: isOrganizeMode ? 'Done' : 'Organize',
          onPressed: () => setState(() => isOrganizeMode = !isOrganizeMode),
        ),
      ],
      child: weekAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppErrorState(
          title: 'Could not load week',
          description: error.toString(),
          onRetry: () => ref.invalidate(weekControllerProvider),
        ),
        data: (weekState) {
          if (weekState.isEmpty) {
            return AppEmptyState(
              title: 'No created days yet',
              description: 'Create only the weekdays you actually want. The app will not invent empty cards for the rest.',
              buttonLabel: 'Add first day',
              onPressed: () => _showCreateDaySheet(ref, weekState),
            );
          }

          return ListView(
            children: [
              AppPrimaryButton(
                label: 'Add created day',
                icon: Icons.add_rounded,
                onPressed: () => _showCreateDaySheet(ref, weekState),
              ),
              if (isOrganizeMode) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Organize mode changes visual order only. Weekday changes happen through Move or Edit.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                children: [
                  for (var index = 0; index < weekState.days.length; index++)
                    SizedBox(
                      width: 360,
                      child: _WeekDayPanel(
                        overview: weekState.days[index],
                        isOrganizeMode: isOrganizeMode,
                        canMoveUp: index > 0,
                        canMoveDown: index < weekState.days.length - 1,
                        onEdit: () => _showEditDaySheet(ref, weekState, weekState.days[index]),
                        onMoveWeekday: () => _showMoveDaySheet(ref, weekState, weekState.days[index]),
                        onDelete: () => _confirmDeleteDay(ref, weekState.days[index].day.id),
                        onMoveUp: index > 0
                            ? () => _moveDayPosition(ref, weekState.days[index].day.id, -1)
                            : null,
                        onMoveDown: index < weekState.days.length - 1
                            ? () => _moveDayPosition(ref, weekState.days[index].day.id, 1)
                            : null,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showCreateDaySheet(
    WidgetRef ref,
    WeekState weekState,
  ) async {
    final availableWeekdays = weekState.availableWeekdays();
    if (availableWeekdays.isEmpty) {
      _showSnackBar('All weekdays are already used.');
      return;
    }

    final draft = await showModalBottomSheet<PlanDayDraft>(
      context: context,
      isScrollControlled: true,
      builder: (context) => PlanDayEditorSheet(
        availableWeekdays: availableWeekdays,
      ),
    );

    if (draft == null || !mounted) {
      return;
    }

    await _runGuarded(
      () => ref.read(weekControllerProvider.notifier).createDay(
            weekday: draft.weekday,
            type: draft.type,
            routineName: draft.routineName,
          ),
      successMessage: 'Created ${draft.weekday.displayName}.',
    );
  }

  Future<void> _showEditDaySheet(
    WidgetRef ref,
    WeekState weekState,
    PlanDayOverview overview,
  ) async {
    final draft = await showModalBottomSheet<PlanDayDraft>(
      context: context,
      isScrollControlled: true,
      builder: (context) => PlanDayEditorSheet(
        initialDay: overview.day,
        availableWeekdays: weekState.availableWeekdays(excludingDayId: overview.day.id),
      ),
    );

    if (draft == null || !mounted) {
      return;
    }

    try {
      await ref.read(weekControllerProvider.notifier).updateDay(
            dayId: overview.day.id,
            weekday: draft.weekday,
            type: draft.type,
            routineName: draft.routineName,
          );
      if (!mounted) {
        return;
      }
      _showSnackBar('Updated ${draft.weekday.displayName}.');
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }

      final shouldForce = error.message.contains('without confirmation')
          ? await showDialog<bool>(
                context: context,
                builder: (context) => const AppConfirmDialog(
                  title: 'Convert to rest day?',
                  description: 'This day still has planned exercises. Confirming will try to remove them before switching the day to rest.',
                  confirmLabel: 'Convert',
                ),
              ) ??
              false
          : false;

      if (!mounted) {
        return;
      }

      if (!shouldForce) {
        if (error.message.isNotEmpty) {
          _showSnackBar(error.message);
        }
        return;
      }

      await _runGuarded(
        () => ref.read(weekControllerProvider.notifier).updateDay(
              dayId: overview.day.id,
              weekday: draft.weekday,
              type: draft.type,
              routineName: draft.routineName,
              forceRestConversion: true,
            ),
        successMessage: 'Converted ${draft.weekday.displayName}.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(error.toString());
    }
  }

  Future<void> _showMoveDaySheet(
    WidgetRef ref,
    WeekState weekState,
    PlanDayOverview overview,
  ) async {
    final availableWeekdays = weekState.availableWeekdays(excludingDayId: overview.day.id);
    if (availableWeekdays.isEmpty) {
      _showSnackBar('No free weekday is available for this move.');
      return;
    }

    final target = await showModalBottomSheet<Weekday>(
      context: context,
      builder: (context) => _MoveWeekdaySheet(
        currentWeekday: overview.day.weekday,
        availableWeekdays: availableWeekdays,
      ),
    );

    if (target == null || !mounted) {
      return;
    }

    await _runGuarded(
      () => ref.read(weekControllerProvider.notifier).moveDayToWeekday(
            dayId: overview.day.id,
            weekday: target,
          ),
      successMessage: 'Moved to ${target.displayName}.',
    );
  }

  Future<void> _confirmDeleteDay(
    WidgetRef ref,
    String dayId,
  ) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => const AppConfirmDialog(
            title: 'Delete created day?',
            description: 'This removes the weekly template day. If there is workout history attached, the repository will block the deletion.',
            confirmLabel: 'Delete',
          ),
        ) ??
        false;
    if (!mounted) {
      return;
    }

    if (!confirmed) {
      return;
    }

    await _runGuarded(
      () => ref.read(weekControllerProvider.notifier).deleteDay(dayId),
      successMessage: 'Day deleted.',
    );
  }

  Future<void> _moveDayPosition(WidgetRef ref, String dayId, int offset) async {
    try {
      await ref.read(weekControllerProvider.notifier).moveDayPosition(
            dayId: dayId,
            offset: offset,
          );
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(error.toString());
    }
  }

  Future<void> _runGuarded(
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    try {
      await action();
      if (!mounted) {
        return;
      }
      _showSnackBar(successMessage);
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(error.toString().replaceFirst('Bad state: ', ''));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _WeekDayPanel extends StatelessWidget {
  const _WeekDayPanel({
    required this.overview,
    required this.isOrganizeMode,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onEdit,
    required this.onMoveWeekday,
    required this.onDelete,
    this.onMoveUp,
    this.onMoveDown,
  });

  final PlanDayOverview overview;
  final bool isOrganizeMode;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onEdit;
  final VoidCallback onMoveWeekday;
  final VoidCallback onDelete;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (overview.day.isTrainingDay)
          TrainingDayCard(
            weekdayLabel: overview.day.weekday.displayName,
            routineName: overview.day.routineName ?? 'Training',
            exerciseSummary: overview.summaryText,
          )
        else
          RestDayCard(
            weekdayLabel: overview.day.weekday.displayName,
            message: 'Recovery and no planned exercises.',
          ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppIconCapsuleButton(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onPressed: onEdit,
            ),
            AppIconCapsuleButton(
              icon: Icons.swap_horiz_rounded,
              label: 'Move',
              onPressed: onMoveWeekday,
            ),
            AppIconCapsuleButton(
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              onPressed: onDelete,
            ),
            if (isOrganizeMode) ...[
              AppIconCapsuleButton(
                icon: Icons.arrow_upward_rounded,
                label: 'Up',
                onPressed: canMoveUp ? onMoveUp : null,
              ),
              AppIconCapsuleButton(
                icon: Icons.arrow_downward_rounded,
                label: 'Down',
                onPressed: canMoveDown ? onMoveDown : null,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class PlanDayDraft {
  const PlanDayDraft({
    required this.weekday,
    required this.type,
    this.routineName,
  });

  final Weekday weekday;
  final PlanDayType type;
  final String? routineName;
}

class PlanDayEditorSheet extends StatefulWidget {
  const PlanDayEditorSheet({
    required this.availableWeekdays,
    super.key,
    this.initialDay,
  });

  final List<Weekday> availableWeekdays;
  final PlanDay? initialDay;

  @override
  State<PlanDayEditorSheet> createState() => _PlanDayEditorSheetState();
}

class _PlanDayEditorSheetState extends State<PlanDayEditorSheet> {
  late PlanDayType selectedType;
  late Weekday selectedWeekday;
  late TextEditingController routineController;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialDay?.type ?? PlanDayType.training;
    selectedWeekday = widget.initialDay?.weekday ?? widget.availableWeekdays.first;
    routineController = TextEditingController(text: widget.initialDay?.routineName ?? '');
  }

  @override
  void dispose() {
    routineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: AppBottomSheetScaffold(
        title: widget.initialDay == null ? 'Create day' : 'Edit day',
        subtitle: 'Weekday stays unique. Rest days cannot keep exercise templates attached.',
        footer: AppPrimaryButton(
          label: widget.initialDay == null ? 'Create day' : 'Save changes',
          onPressed: _submit,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Weekday>(
              initialValue: selectedWeekday,
              items: [
                if (widget.initialDay != null)
                  DropdownMenuItem(
                    value: widget.initialDay!.weekday,
                    child: Text(widget.initialDay!.weekday.displayName),
                  ),
                for (final weekday in widget.availableWeekdays)
                  if (weekday != widget.initialDay?.weekday)
                    DropdownMenuItem(
                      value: weekday,
                      child: Text(weekday.displayName),
                    ),
              ],
              decoration: const InputDecoration(labelText: 'Weekday'),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedWeekday = value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SegmentedButton<PlanDayType>(
              segments: const [
                ButtonSegment(
                  value: PlanDayType.training,
                  label: Text('Training'),
                  icon: Icon(Icons.fitness_center),
                ),
                ButtonSegment(
                  value: PlanDayType.rest,
                  label: Text('Rest'),
                  icon: Icon(Icons.spa_outlined),
                ),
              ],
              selected: {selectedType},
              onSelectionChanged: (selection) {
                setState(() => selectedType = selection.first);
              },
            ),
            if (selectedType == PlanDayType.training) ...[
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: routineController,
                decoration: const InputDecoration(
                  labelText: 'Routine name',
                  hintText: 'Upper Strength',
                ),
              ),
            ],
            if (validationMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                validationMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _submit() {
    final trimmedName = routineController.text.trim();
    if (selectedType == PlanDayType.training && trimmedName.isEmpty) {
      setState(() => validationMessage = 'Training days require a routine name.');
      return;
    }

    Navigator.of(context).pop(
      PlanDayDraft(
        weekday: selectedWeekday,
        type: selectedType,
        routineName: selectedType == PlanDayType.training ? trimmedName : null,
      ),
    );
  }
}

class _MoveWeekdaySheet extends StatelessWidget {
  const _MoveWeekdaySheet({
    required this.currentWeekday,
    required this.availableWeekdays,
  });

  final Weekday currentWeekday;
  final List<Weekday> availableWeekdays;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetScaffold(
      title: 'Move day',
      subtitle: 'Current weekday: ${currentWeekday.displayName}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final weekday in availableWeekdays) ...[
            ListTile(
              title: Text(weekday.displayName),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).pop(weekday),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}