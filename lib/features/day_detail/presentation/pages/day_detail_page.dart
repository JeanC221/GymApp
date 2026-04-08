import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartfit/app/theme/tokens/app_breakpoints.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';
import 'package:smartfit/features/day_detail/presentation/controllers/day_detail_controller.dart';
import 'package:smartfit/features/shared/presentation/layouts/app_page_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_bottom_sheet_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_empty_state.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_error_state.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_icon_capsule_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_primary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_secondary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/cardio_exercise_card.dart';
import 'package:smartfit/features/shared/presentation/widgets/strength_exercise_card.dart';

class DayDetailPage extends ConsumerWidget {
  const DayDetailPage({required this.dayId, super.key});

  static const routeName = 'day-detail';
  static const routePath = '/week/day/:dayId';

  static String buildPath(String dayId) => '/week/day/$dayId';

  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(dayDetailProvider(dayId));

    return detailAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: AppErrorState(
          title: 'Could not load day detail',
          description: error.toString(),
          onRetry: () => ref.invalidate(dayDetailProvider(dayId)),
        ),
      ),
      data: (state) {
        final theme = Theme.of(context);
        final controller = ref.read(dayDetailControllerProvider(dayId));

        return AppPageScaffold(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.day.weekday.displayName, style: theme.textTheme.displaySmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.day.routineName ?? 'Rest day',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.isTrainingDay
                    ? 'Template and real execution stay separate here: planned exercises live above, today session data lives below.'
                    : 'Rest days keep the schedule visible without allowing exercise templates.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            AppIconCapsuleButton(
              icon: Icons.arrow_back_rounded,
              label: 'Back',
              onPressed: () => context.pop(),
            ),
          ],
          child: _DayDetailContent(
            state: state,
            controller: controller,
          ),
        );
      },
    );
  }
}

class _DayDetailContent extends StatelessWidget {
  const _DayDetailContent({
    required this.state,
    required this.controller,
  });

  final DayDetailState state;
  final DayDetailController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.medium;
        final onStartSession = state.isTrainingDay
            ? () => _runAction(
                  context,
                  () => controller.startTodaySession(),
                  successMessage: 'Today session started.',
                )
            : null;
        final onCompleteSession = state.isTrainingDay
            ? () => _runAction(
                  context,
                  () => controller.completeTodaySession(),
                  successMessage: 'Today session marked as completed.',
                )
            : null;
        final sections = _buildMainSections(
          context,
          onStartSession: onStartSession,
          onCompleteSession: onCompleteSession,
        );

        if (!isTablet) {
          return ListView(children: sections);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ListView(children: sections)),
            const SizedBox(width: AppSpacing.xl),
            SizedBox(
              width: 320,
              child: SingleChildScrollView(
                child: _DayInspectorPanel(
                  state: state,
                  onStartSession: onStartSession,
                  onCompleteSession: onCompleteSession,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildMainSections(
    BuildContext context, {
    required VoidCallback? onStartSession,
    required VoidCallback? onCompleteSession,
  }) {
    return [
      _SessionHeader(
        state: state,
        onStartSession: onStartSession,
        onCompleteSession: onCompleteSession,
      ),
      const SizedBox(height: AppSpacing.xl),
      if (state.isRestDay)
        const AppEmptyState(
          title: 'Rest day',
          description: 'This day intentionally has no exercise templates or session logging.',
        )
      else ...[
        LayoutBuilder(
          builder: (context, constraints) {
            final shouldStack = constraints.maxWidth < AppBreakpoints.compact;
            if (shouldStack) {
              return Column(
                children: [
                  AppPrimaryButton(
                    label: 'Add strength',
                    icon: Icons.fitness_center,
                    onPressed: () => _showStrengthTemplateSheet(
                      context,
                      onSave: (draft) => _runAction(
                        context,
                        () => controller.addStrengthExercise(
                          displayName: draft.displayName,
                          targetSets: draft.targetSets,
                          targetReps: draft.targetReps,
                        ),
                        successMessage: 'Strength exercise added.',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppPrimaryButton(
                    label: 'Add cardio',
                    icon: Icons.directions_run_rounded,
                    onPressed: () => _showCardioTemplateSheet(
                      context,
                      onSave: (draft) => _runAction(
                        context,
                        () => controller.addCardioExercise(
                          displayName: draft.displayName,
                          cardioType: draft.cardioType,
                          durationMinutes: draft.durationMinutes,
                          incline: draft.incline,
                        ),
                        successMessage: 'Cardio block added.',
                      ),
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Add strength',
                    icon: Icons.fitness_center,
                    onPressed: () => _showStrengthTemplateSheet(
                      context,
                      onSave: (draft) => _runAction(
                        context,
                        () => controller.addStrengthExercise(
                          displayName: draft.displayName,
                          targetSets: draft.targetSets,
                          targetReps: draft.targetReps,
                        ),
                        successMessage: 'Strength exercise added.',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Add cardio',
                    icon: Icons.directions_run_rounded,
                    onPressed: () => _showCardioTemplateSheet(
                      context,
                      onSave: (draft) => _runAction(
                        context,
                        () => controller.addCardioExercise(
                          displayName: draft.displayName,
                          cardioType: draft.cardioType,
                          durationMinutes: draft.durationMinutes,
                          incline: draft.incline,
                        ),
                        successMessage: 'Cardio block added.',
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        if (!state.hasExercises)
          const AppEmptyState(
            title: 'No exercises yet',
            description: 'Add planned strength or cardio blocks before you start logging the real session.',
          )
        else ...[
          _ExerciseReorderList(
            state: state,
            controller: controller,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ],
    ];
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.state,
    this.onStartSession,
    this.onCompleteSession,
  });

  final DayDetailState state;
  final VoidCallback? onStartSession;
  final VoidCallback? onCompleteSession;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionStatus = switch (state.todaySession?.sessionStatus) {
      WorkoutSessionStatus.inProgress => 'In progress',
      WorkoutSessionStatus.completed => 'Completed',
      WorkoutSessionStatus.skipped => 'Skipped',
      WorkoutSessionStatus.pending => 'Pending',
      null => 'Not started',
    };

    return AppInteractiveSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today session', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Chip(label: Text(sessionStatus)),
          const SizedBox(height: AppSpacing.md),
          Text(
            state.isTrainingDay
                ? 'Last used weight is shown as reference only. You still log the real performed values manually.'
                : 'No session logging is required for rest days.',
            style: theme.textTheme.bodyMedium,
          ),
          if (state.isTrainingDay) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: state.todaySession == null ? 'Start session' : 'Resume session',
                    onPressed: onStartSession,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Complete session',
                    onPressed: onCompleteSession,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StrengthExerciseSection extends StatelessWidget {
  const _StrengthExerciseSection({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onLog,
    this.surfaceState = AppSurfaceState.idle,
    this.onMoveToDay,
    this.onCopyToDay,
  });

  final DayExerciseDetail item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLog;
  final AppSurfaceState surfaceState;
  final VoidCallback? onMoveToDay;
  final VoidCallback? onCopyToDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StrengthExerciseCard(
          name: item.exercise.displayName,
          targetSummary:
              '${item.strengthTemplate!.targetSets} sets x ${item.strengthTemplate!.targetReps} reps',
          lastWeightSummary: item.lastUsedWeight == null
              ? 'Last used: none yet'
              : 'Last used: ${item.lastUsedWeight!.toStringAsFixed(item.lastUsedWeight! % 1 == 0 ? 0 : 1)} kg',
          state: surfaceState,
          onTap: onLog,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Completed sets today: ${item.completedStrengthSets}/${item.strengthTemplate!.targetSets}',
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppIconCapsuleButton(
              icon: Icons.checklist_rounded,
              label: 'Log sets',
              onPressed: onLog,
            ),
            AppIconCapsuleButton(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onPressed: onEdit,
            ),
            if (onMoveToDay != null)
              AppIconCapsuleButton(
                icon: Icons.redo_rounded,
                label: 'Move',
                onPressed: onMoveToDay,
              ),
            if (onCopyToDay != null)
              AppIconCapsuleButton(
                icon: Icons.content_copy_rounded,
                label: 'Copy',
                onPressed: onCopyToDay,
              ),
            AppIconCapsuleButton(
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}

class _CardioExerciseSection extends StatelessWidget {
  const _CardioExerciseSection({
    required this.item,
    required this.onEditTemplate,
    required this.onDeleteExercise,
    required this.onLog,
    this.surfaceState = AppSurfaceState.idle,
    this.onMoveToDay,
    this.onCopyToDay,
    this.onDeleteLog,
  });

  final DayExerciseDetail item;
  final VoidCallback onEditTemplate;
  final VoidCallback onDeleteExercise;
  final VoidCallback onLog;
  final AppSurfaceState surfaceState;
  final VoidCallback? onMoveToDay;
  final VoidCallback? onCopyToDay;
  final VoidCallback? onDeleteLog;

  @override
  Widget build(BuildContext context) {
    final loggedSummary = item.cardioLog == null
        ? 'No cardio log saved for today'
        : 'Today: ${item.cardioLog!.durationMinutes} min${item.cardioLog!.incline == null ? '' : ', incline ${item.cardioLog!.incline}'}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardioExerciseCard(
          name: item.exercise.displayName,
          durationSummary: item.cardioTemplate!.defaultDurationMinutes == null
              ? 'Manual cardio block'
              : '${item.cardioTemplate!.defaultDurationMinutes} min block',
          detailSummary: loggedSummary,
          state: surfaceState,
          onTap: onLog,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppIconCapsuleButton(
              icon: Icons.timer_outlined,
              label: 'Log cardio',
              onPressed: onLog,
            ),
            AppIconCapsuleButton(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onPressed: onEditTemplate,
            ),
            if (onMoveToDay != null)
              AppIconCapsuleButton(
                icon: Icons.redo_rounded,
                label: 'Move',
                onPressed: onMoveToDay,
              ),
            if (onCopyToDay != null)
              AppIconCapsuleButton(
                icon: Icons.content_copy_rounded,
                label: 'Copy',
                onPressed: onCopyToDay,
              ),
            if (onDeleteLog != null)
              AppIconCapsuleButton(
                icon: Icons.remove_circle_outline_rounded,
                label: 'Clear log',
                onPressed: onDeleteLog,
              ),
            AppIconCapsuleButton(
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              onPressed: onDeleteExercise,
            ),
          ],
        ),
      ],
    );
  }
}

class StrengthExerciseTemplateDraft {
  const StrengthExerciseTemplateDraft({
    required this.displayName,
    required this.targetSets,
    required this.targetReps,
  });

  final String displayName;
  final int targetSets;
  final int targetReps;
}

class _ExerciseReorderList extends StatefulWidget {
  const _ExerciseReorderList({
    required this.state,
    required this.controller,
  });

  final DayDetailState state;
  final DayDetailController controller;

  @override
  State<_ExerciseReorderList> createState() => _ExerciseReorderListState();
}

class _ExerciseReorderListState extends State<_ExerciseReorderList> {
  int? draggingIndex;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      physics: const NeverScrollableScrollPhysics(),
      onReorderStart: (index) => setState(() => draggingIndex = index),
      onReorderEnd: (index) => setState(() => draggingIndex = null),
      itemCount: widget.state.exercises.length,
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: animation.drive(Tween(begin: 0.92, end: 1)),
            child: child,
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        var targetIndex = newIndex;
        if (newIndex > oldIndex) {
          targetIndex -= 1;
        }
        setState(() => draggingIndex = null);
        _runAction(
          context,
          () => widget.controller.reorderExercise(
            exerciseId: widget.state.exercises[oldIndex].exercise.id,
            targetIndex: targetIndex,
          ),
          successMessage: 'Exercise order updated.',
        );
      },
      itemBuilder: (context, index) {
        final item = widget.state.exercises[index];
        final isDragging = draggingIndex == index;
        return Padding(
          key: ValueKey(item.exercise.id),
          padding: EdgeInsets.only(
            bottom: index == widget.state.exercises.length - 1 ? 0 : AppSpacing.xl,
          ),
          child: _ExerciseReorderItem(
            index: index,
            isDragging: isDragging,
            isDropTarget: draggingIndex != null && !isDragging,
            child: item.type == ExerciseType.strength
                ? _StrengthExerciseSection(
                    item: item,
                    surfaceState: isDragging ? AppSurfaceState.dragging : AppSurfaceState.idle,
                    onEdit: () => _showStrengthTemplateSheet(
                      context,
                      initialDraft: StrengthExerciseTemplateDraft(
                        displayName: item.exercise.displayName,
                        targetSets: item.strengthTemplate!.targetSets,
                        targetReps: item.strengthTemplate!.targetReps,
                      ),
                      onSave: (draft) => _runStrengthTemplateAction(
                        context,
                        action: (trimOverflowLogs) => widget.controller.updateStrengthExercise(
                          exercise: item.exercise,
                          template: item.strengthTemplate!,
                          displayName: draft.displayName,
                          targetSets: draft.targetSets,
                          targetReps: draft.targetReps,
                          trimOverflowLogs: trimOverflowLogs,
                        ),
                        successMessage: 'Strength exercise updated.',
                      ),
                    ),
                    onDelete: () => _confirmDeleteExercise(
                      context,
                      onDelete: () => widget.controller.deleteExercise(item.exercise.id),
                    ),
                    onMoveToDay: widget.state.hasTransferTargets
                        ? () => _showExerciseTransferSheet(
                              context,
                              title: 'Move exercise',
                              subtitle: 'Move this exercise template to another training day and keep the weekly order stable.',
                              targetDays: widget.state.transferTargets,
                              onSelect: (targetDay) => _runAction(
                                context,
                                () => widget.controller.moveExerciseToDay(
                                  item: item,
                                  targetDayId: targetDay.id,
                                ),
                                successMessage: 'Exercise moved to ${_planDayLabel(targetDay)}.',
                              ),
                            )
                        : null,
                    onCopyToDay: widget.state.hasTransferTargets
                        ? () => _showExerciseTransferSheet(
                              context,
                              title: 'Copy exercise',
                              subtitle: 'Create a new copy of this exercise template in another training day.',
                              targetDays: widget.state.transferTargets,
                              onSelect: (targetDay) => _runAction(
                                context,
                                () => widget.controller.copyExerciseToDay(
                                  item: item,
                                  targetDayId: targetDay.id,
                                ),
                                successMessage: 'Exercise copied to ${_planDayLabel(targetDay)}.',
                              ),
                            )
                        : null,
                    onLog: () => _showStrengthLogSheet(
                      context,
                      item,
                      onSave: (drafts) => _runAction(
                        context,
                        () => widget.controller.saveStrengthLogs(
                          exercise: item.exercise,
                          drafts: drafts,
                        ),
                        successMessage: 'Strength logs saved.',
                      ),
                    ),
                  )
                : _CardioExerciseSection(
                    item: item,
                    surfaceState: isDragging ? AppSurfaceState.dragging : AppSurfaceState.idle,
                    onEditTemplate: () => _showCardioTemplateSheet(
                      context,
                      initialDraft: CardioExerciseTemplateDraft(
                        displayName: item.exercise.displayName,
                        cardioType: item.cardioTemplate!.cardioType,
                        durationMinutes: item.cardioTemplate!.defaultDurationMinutes ?? 20,
                        incline: item.cardioTemplate!.defaultIncline,
                      ),
                      onSave: (draft) => _runAction(
                        context,
                        () => widget.controller.updateCardioExercise(
                          exercise: item.exercise,
                          template: item.cardioTemplate!,
                          displayName: draft.displayName,
                          cardioType: draft.cardioType,
                          durationMinutes: draft.durationMinutes,
                          incline: draft.incline,
                        ),
                        successMessage: 'Cardio block updated.',
                      ),
                    ),
                    onDeleteExercise: () => _confirmDeleteExercise(
                      context,
                      onDelete: () => widget.controller.deleteExercise(item.exercise.id),
                    ),
                    onMoveToDay: widget.state.hasTransferTargets
                        ? () => _showExerciseTransferSheet(
                              context,
                              title: 'Move cardio block',
                              subtitle: 'Move this planned cardio block to another training day.',
                              targetDays: widget.state.transferTargets,
                              onSelect: (targetDay) => _runAction(
                                context,
                                () => widget.controller.moveExerciseToDay(
                                  item: item,
                                  targetDayId: targetDay.id,
                                ),
                                successMessage: 'Exercise moved to ${_planDayLabel(targetDay)}.',
                              ),
                            )
                        : null,
                    onCopyToDay: widget.state.hasTransferTargets
                        ? () => _showExerciseTransferSheet(
                              context,
                              title: 'Copy cardio block',
                              subtitle: 'Create a new cardio block copy in another training day.',
                              targetDays: widget.state.transferTargets,
                              onSelect: (targetDay) => _runAction(
                                context,
                                () => widget.controller.copyExerciseToDay(
                                  item: item,
                                  targetDayId: targetDay.id,
                                ),
                                successMessage: 'Exercise copied to ${_planDayLabel(targetDay)}.',
                              ),
                            )
                        : null,
                    onLog: () => _showCardioLogSheet(
                      context,
                      item,
                      onSave: (draft) => _runAction(
                        context,
                        () => widget.controller.saveCardioLog(
                          exercise: item.exercise,
                          cardioType: draft.cardioType,
                          durationMinutes: draft.durationMinutes,
                          incline: draft.incline,
                        ),
                        successMessage: 'Cardio log saved.',
                      ),
                    ),
                    onDeleteLog: item.cardioLog == null
                        ? null
                        : () => _runAction(
                              context,
                              () => widget.controller.deleteCardioLog(item.exercise.id),
                              successMessage: 'Cardio log removed.',
                            ),
                  ),
          ),
        );
      },
    );
  }
}

class _ExerciseReorderItem extends StatelessWidget {
  const _ExerciseReorderItem({
    required this.index,
    required this.child,
    required this.isDragging,
    required this.isDropTarget,
  });

  final int index;
  final Widget child;
  final bool isDragging;
  final bool isDropTarget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInteractiveSurface(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          state: isDragging
              ? AppSurfaceState.dragging
              : isDropTarget
                  ? AppSurfaceState.dropTarget
                  : AppSurfaceState.idle,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isDragging ? 'Dragging exercise' : isDropTarget ? 'Drop exercise here' : 'Drag to reorder',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              ReorderableDelayedDragStartListener(
                index: index,
                child: const Icon(Icons.drag_indicator_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

class _DayInspectorPanel extends StatelessWidget {
  const _DayInspectorPanel({
    required this.state,
    this.onStartSession,
    this.onCompleteSession,
  });

  final DayDetailState state;
  final VoidCallback? onStartSession;
  final VoidCallback? onCompleteSession;

  @override
  Widget build(BuildContext context) {
    final completedStrengthSets = state.exercises.fold<int>(
      0,
      (count, item) => count + item.completedStrengthSets,
    );
    final loggedCardioBlocks = state.exercises.where((item) => item.cardioLog != null).length;
    final sessionStatus = switch (state.todaySession?.sessionStatus) {
      WorkoutSessionStatus.inProgress => 'In progress',
      WorkoutSessionStatus.completed => 'Completed',
      WorkoutSessionStatus.skipped => 'Skipped',
      WorkoutSessionStatus.pending => 'Pending',
      null => 'Not started',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInteractiveSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Day inspector', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(sessionStatus, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.isTrainingDay
                    ? 'Use the side panel to keep session context visible while editing templates and logs.'
                    : 'Rest days stay visible in the schedule but keep exercise editing disabled.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (state.isTrainingDay) ...[
                const SizedBox(height: AppSpacing.lg),
                AppPrimaryButton(
                  label: state.todaySession == null ? 'Start session' : 'Resume session',
                  onPressed: onStartSession,
                ),
                const SizedBox(height: AppSpacing.md),
                AppSecondaryButton(
                  label: 'Complete session',
                  onPressed: onCompleteSession,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppInteractiveSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Template summary', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              _InspectorMetricRow(label: 'Planned blocks', value: '${state.exercises.length}'),
              _InspectorMetricRow(label: 'Completed sets today', value: '$completedStrengthSets'),
              _InspectorMetricRow(label: 'Logged cardio blocks', value: '$loggedCardioBlocks'),
              _InspectorMetricRow(label: 'Transfer targets', value: '${state.transferTargets.length}'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppInteractiveSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Editing cues', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.hasExercises
                    ? 'Drag handles lift the active card and highlight valid drop zones while you reorder the template.'
                    : 'Once planned blocks exist, tablet keeps your editing context and session summary side by side.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InspectorMetricRow extends StatelessWidget {
  const _InspectorMetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          const SizedBox(width: AppSpacing.md),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class CardioExerciseTemplateDraft {
  const CardioExerciseTemplateDraft({
    required this.displayName,
    required this.cardioType,
    required this.durationMinutes,
    this.incline,
  });

  final String displayName;
  final String cardioType;
  final int durationMinutes;
  final double? incline;
}

class CardioLogDraft {
  const CardioLogDraft({
    required this.cardioType,
    required this.durationMinutes,
    this.incline,
  });

  final String cardioType;
  final int durationMinutes;
  final double? incline;
}

Future<void> _showStrengthTemplateSheet(
  BuildContext context, {
  StrengthExerciseTemplateDraft? initialDraft,
  required Future<void> Function(StrengthExerciseTemplateDraft draft) onSave,
}) async {
  final draft = await showModalBottomSheet<StrengthExerciseTemplateDraft>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _StrengthTemplateSheet(initialDraft: initialDraft),
  );
  if (draft == null || !context.mounted) {
    return;
  }
  await onSave(draft);
}

Future<void> _showCardioTemplateSheet(
  BuildContext context, {
  CardioExerciseTemplateDraft? initialDraft,
  required Future<void> Function(CardioExerciseTemplateDraft draft) onSave,
}) async {
  final draft = await showModalBottomSheet<CardioExerciseTemplateDraft>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _CardioTemplateSheet(initialDraft: initialDraft),
  );
  if (draft == null || !context.mounted) {
    return;
  }
  await onSave(draft);
}

Future<void> _showStrengthLogSheet(
  BuildContext context,
  DayExerciseDetail item, {
  required Future<void> Function(List<StrengthSetLogDraft> drafts) onSave,
}) async {
  final drafts = await showModalBottomSheet<List<StrengthSetLogDraft>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _StrengthLogSheet(item: item),
  );
  if (drafts == null || !context.mounted) {
    return;
  }
  await onSave(drafts);
}

Future<void> _showCardioLogSheet(
  BuildContext context,
  DayExerciseDetail item, {
  required Future<void> Function(CardioLogDraft draft) onSave,
}) async {
  final draft = await showModalBottomSheet<CardioLogDraft>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _CardioLogSheet(item: item),
  );
  if (draft == null || !context.mounted) {
    return;
  }
  await onSave(draft);
}

Future<void> _showExerciseTransferSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  required List<PlanDay> targetDays,
  required Future<void> Function(PlanDay day) onSelect,
}) async {
  final targetDay = await showModalBottomSheet<PlanDay>(
    context: context,
    isScrollControlled: true,
    builder: (context) => ExerciseTransferSheet(
      title: title,
      subtitle: subtitle,
      targetDays: targetDays,
      onSelectDay: (day) => Navigator.of(context).pop(day),
    ),
  );
  if (targetDay == null || !context.mounted) {
    return;
  }
  await onSelect(targetDay);
}

Future<void> _confirmDeleteExercise(
  BuildContext context, {
  required Future<void> Function() onDelete,
}) async {
  final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => const AppConfirmDialog(
          title: 'Delete exercise?',
          description: 'If this exercise already has persisted workout history, the repository will block the deletion.',
          confirmLabel: 'Delete',
        ),
      ) ??
      false;
  if (!confirmed || !context.mounted) {
    return;
  }
  await onDelete();
}

Future<void> _runStrengthTemplateAction(
  BuildContext context, {
  required Future<void> Function(bool trimOverflowLogs) action,
  required String successMessage,
}) async {
  try {
    await action(false);
    if (!context.mounted) {
      return;
    }
    _showActionSuccess(context, successMessage);
  } on StrengthSetReductionConflict catch (conflict) {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => StrengthSetTrimConfirmDialog(
            conflict: conflict,
          ),
        ) ??
        false;
    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await action(true);
      if (!context.mounted) {
        return;
      }
      _showActionSuccess(context, '$successMessage Overflow logs were trimmed.');
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      _showActionError(context, error);
    }
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    _showActionError(context, error);
  }
}

Future<void> _runAction(
  BuildContext context,
  Future<void> Function() action, {
  required String successMessage,
}) async {
  try {
    await action();
    if (!context.mounted) {
      return;
    }
    _showActionSuccess(context, successMessage);
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    _showActionError(context, error);
  }
}

void _showActionSuccess(BuildContext context, String message) {
  if (!context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void _showActionError(BuildContext context, Object error) {
  if (!context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Bad state: ', ''))),
    );
}

String _planDayLabel(PlanDay day) {
  return day.routineName == null
      ? day.weekday.displayName
      : '${day.weekday.displayName} · ${day.routineName}';
}

class _StrengthTemplateSheet extends StatefulWidget {
  const _StrengthTemplateSheet({this.initialDraft});

  final StrengthExerciseTemplateDraft? initialDraft;

  @override
  State<_StrengthTemplateSheet> createState() => _StrengthTemplateSheetState();
}

class _StrengthTemplateSheetState extends State<_StrengthTemplateSheet> {
  late final TextEditingController nameController;
  late final TextEditingController setsController;
  late final TextEditingController repsController;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialDraft?.displayName ?? '');
    setsController = TextEditingController(text: widget.initialDraft?.targetSets.toString() ?? '4');
    repsController = TextEditingController(text: widget.initialDraft?.targetReps.toString() ?? '8');
  }

  @override
  void dispose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheetScaffold(
        title: widget.initialDraft == null ? 'Add strength' : 'Edit strength',
        subtitle: 'Planned sets and reps live in the template. Real reps and weight are logged per session.',
        footer: AppPrimaryButton(
          label: widget.initialDraft == null ? 'Add strength' : 'Save changes',
          onPressed: _submit,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Exercise name'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Target sets'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Target reps'),
                  ),
                ),
              ],
            ),
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
    final name = nameController.text.trim();
    final sets = int.tryParse(setsController.text.trim());
    final reps = int.tryParse(repsController.text.trim());
    if (name.isEmpty || sets == null || sets <= 0 || reps == null || reps <= 0) {
      setState(() => validationMessage = 'Enter a valid name, sets and reps.');
      return;
    }
    Navigator.of(context).pop(
      StrengthExerciseTemplateDraft(
        displayName: name,
        targetSets: sets,
        targetReps: reps,
      ),
    );
  }
}

class ExerciseTransferSheet extends StatelessWidget {
  const ExerciseTransferSheet({
    required this.title,
    required this.subtitle,
    required this.targetDays,
    required this.onSelectDay,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<PlanDay> targetDays;
  final ValueChanged<PlanDay> onSelectDay;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetScaffold(
      title: title,
      subtitle: subtitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final day in targetDays) ...[
            AppInteractiveSurface(
              onTap: () => onSelectDay(day),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _planDayLabel(day),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Target day for this template action.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class StrengthSetTrimConfirmDialog extends StatelessWidget {
  const StrengthSetTrimConfirmDialog({
    required this.conflict,
    super.key,
    this.onConfirm,
  });

  final StrengthSetReductionConflict conflict;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      title: 'Trim saved set logs?',
      description:
          '${conflict.toString()} Confirm to keep the first ${conflict.keepSets} planned sets and discard the overflow logs.',
      confirmLabel: 'Trim and save',
      onConfirm: onConfirm,
    );
  }
}

class _CardioTemplateSheet extends StatefulWidget {
  const _CardioTemplateSheet({this.initialDraft});

  final CardioExerciseTemplateDraft? initialDraft;

  @override
  State<_CardioTemplateSheet> createState() => _CardioTemplateSheetState();
}

class _CardioTemplateSheetState extends State<_CardioTemplateSheet> {
  late final TextEditingController nameController;
  late final TextEditingController typeController;
  late final TextEditingController durationController;
  late final TextEditingController inclineController;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialDraft?.displayName ?? '');
    typeController = TextEditingController(text: widget.initialDraft?.cardioType ?? '');
    durationController = TextEditingController(
      text: widget.initialDraft?.durationMinutes.toString() ?? '20',
    );
    inclineController = TextEditingController(
      text: widget.initialDraft?.incline?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    durationController.dispose();
    inclineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheetScaffold(
        title: widget.initialDraft == null ? 'Add cardio' : 'Edit cardio',
        subtitle: 'Cardio V1 stays lean: type, duration and optional incline.',
        footer: AppPrimaryButton(
          label: widget.initialDraft == null ? 'Add cardio' : 'Save changes',
          onPressed: _submit,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Cardio type'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Duration (min)'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: inclineController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Incline (optional)'),
                  ),
                ),
              ],
            ),
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
    final name = nameController.text.trim();
    final cardioType = typeController.text.trim();
    final duration = int.tryParse(durationController.text.trim());
    final inclineText = inclineController.text.trim();
    final incline = inclineText.isEmpty ? null : double.tryParse(inclineText);
    if (name.isEmpty || cardioType.isEmpty || duration == null || duration <= 0) {
      setState(() => validationMessage = 'Enter a valid display name, cardio type and duration.');
      return;
    }
    if (inclineText.isNotEmpty && incline == null) {
      setState(() => validationMessage = 'Incline must be a valid number.');
      return;
    }
    Navigator.of(context).pop(
      CardioExerciseTemplateDraft(
        displayName: name,
        cardioType: cardioType,
        durationMinutes: duration,
        incline: incline,
      ),
    );
  }
}

class _StrengthLogSheet extends StatefulWidget {
  const _StrengthLogSheet({required this.item});

  final DayExerciseDetail item;

  @override
  State<_StrengthLogSheet> createState() => _StrengthLogSheetState();
}

class _StrengthLogSheetState extends State<_StrengthLogSheet> {
  late final List<TextEditingController> repsControllers;
  late final List<TextEditingController> weightControllers;
  late final List<bool> completed;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    final setCount = widget.item.strengthTemplate!.targetSets;
    repsControllers = List.generate(setCount, (index) {
      final existing = _logAt(index);
      return TextEditingController(text: existing?.performedReps?.toString() ?? '');
    });
    weightControllers = List.generate(setCount, (index) {
      final existing = _logAt(index);
      return TextEditingController(text: existing?.performedWeight?.toString() ?? '');
    });
    completed = List.generate(
      setCount,
      (index) => _logAt(index)?.isCompleted ?? false,
    );
  }

  @override
  void dispose() {
    for (final controller in repsControllers) {
      controller.dispose();
    }
    for (final controller in weightControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetSets = widget.item.strengthTemplate!.targetSets;
    final targetReps = widget.item.strengthTemplate!.targetReps;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheetScaffold(
        title: 'Log sets',
        subtitle: widget.item.lastUsedWeight == null
            ? 'No last used reference yet.'
            : 'Last used reference: ${widget.item.lastUsedWeight} kg. This is not auto-filled.',
        footer: AppPrimaryButton(
          label: 'Save set logs',
          onPressed: _submit,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < targetSets; index++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      value: completed[index],
                      onChanged: (value) => setState(() => completed[index] = value ?? false),
                      contentPadding: EdgeInsets.zero,
                      title: Text('Set ${index + 1}'),
                      subtitle: Text('Target: $targetReps reps'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: repsControllers[index],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Reps'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: weightControllers[index],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Weight'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (validationMessage != null)
              Text(
                validationMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }

  StrengthSetLog? _logAt(int index) {
    for (final log in widget.item.strengthLogs) {
      if (log.setIndex == index) {
        return log;
      }
    }
    return null;
  }

  void _submit() {
    final drafts = <StrengthSetLogDraft>[];
    for (var index = 0; index < repsControllers.length; index++) {
      final repsText = repsControllers[index].text.trim();
      final weightText = weightControllers[index].text.trim();
      final reps = repsText.isEmpty ? null : int.tryParse(repsText);
      final weight = weightText.isEmpty ? null : double.tryParse(weightText);
      if (repsText.isNotEmpty && reps == null) {
        setState(() => validationMessage = 'Reps must be valid numbers.');
        return;
      }
      if (weightText.isNotEmpty && weight == null) {
        setState(() => validationMessage = 'Weight must be a valid number.');
        return;
      }
      if (completed[index] && (reps == null || weight == null)) {
        setState(() => validationMessage = 'Completed sets require reps and real weight.');
        return;
      }
      drafts.add(
        StrengthSetLogDraft(
          isCompleted: completed[index],
          performedReps: reps,
          performedWeight: weight,
        ),
      );
    }
    Navigator.of(context).pop(drafts);
  }
}

class _CardioLogSheet extends StatefulWidget {
  const _CardioLogSheet({required this.item});

  final DayExerciseDetail item;

  @override
  State<_CardioLogSheet> createState() => _CardioLogSheetState();
}

class _CardioLogSheetState extends State<_CardioLogSheet> {
  late final TextEditingController typeController;
  late final TextEditingController durationController;
  late final TextEditingController inclineController;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController(
      text: widget.item.cardioLog?.cardioType ?? widget.item.cardioTemplate!.cardioType,
    );
    durationController = TextEditingController(
      text: (widget.item.cardioLog?.durationMinutes ??
              widget.item.cardioTemplate!.defaultDurationMinutes ??
              20)
          .toString(),
    );
    inclineController = TextEditingController(
      text: (widget.item.cardioLog?.incline ?? widget.item.cardioTemplate!.defaultIncline)
              ?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    typeController.dispose();
    durationController.dispose();
    inclineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheetScaffold(
        title: 'Log cardio',
        subtitle: 'Manual V1 keeps just the fields you approved: type, duration and optional incline.',
        footer: AppPrimaryButton(
          label: 'Save cardio log',
          onPressed: _submit,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Cardio type'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (min)'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: inclineController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Incline (optional)'),
            ),
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
    final type = typeController.text.trim();
    final duration = int.tryParse(durationController.text.trim());
    final inclineText = inclineController.text.trim();
    final incline = inclineText.isEmpty ? null : double.tryParse(inclineText);
    if (type.isEmpty || duration == null || duration <= 0) {
      setState(() => validationMessage = 'Enter a valid cardio type and duration.');
      return;
    }
    if (inclineText.isNotEmpty && incline == null) {
      setState(() => validationMessage = 'Incline must be a valid number.');
      return;
    }
    Navigator.of(context).pop(
      CardioLogDraft(
        cardioType: type,
        durationMinutes: duration,
        incline: incline,
      ),
    );
  }
}