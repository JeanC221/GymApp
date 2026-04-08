import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/core/data/backup/smartfit_backup_service.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';
import 'package:smartfit/features/shared/presentation/layouts/app_page_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_error_state.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_primary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_secondary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_segmented_control.dart';
import 'package:smartfit/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:smartfit/features/settings/presentation/providers/backup_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const routeName = 'settings';
  static const routePath = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(currentAppSettingsProvider);
    final backupState = ref.watch(backupControllerProvider);
    final isBackupBusy = backupState.isLoading;

    return AppPageScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Theme, units and backup', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Global preferences now persist here, and backups can export or replace the local dataset with schema validation.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      child: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppErrorState(
          title: 'Could not load settings',
          description: error.toString(),
          onRetry: () => ref.invalidate(currentAppSettingsProvider),
        ),
        data: (settings) => ListView(
          children: [
            _SettingsCard(
              title: 'Appearance',
              subtitle: 'Choose whether SmartFit follows the system palette or forces a light or dark theme.',
              icon: Icons.contrast_outlined,
              child: IgnorePointer(
                ignoring: isBackupBusy,
                child: AppSegmentedControl<AppThemePreference>(
                  value: settings.themeMode,
                  segments: const [
                    AppSegment(value: AppThemePreference.system, label: 'System'),
                    AppSegment(value: AppThemePreference.light, label: 'Light'),
                    AppSegment(value: AppThemePreference.dark, label: 'Dark'),
                  ],
                  onChanged: (value) async {
                    await ref.read(settingsControllerProvider).saveThemeMode(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsCard(
              title: 'Training units',
              subtitle: 'The selected unit becomes the default reference across plans, logs and progress surfaces.',
              icon: Icons.monitor_weight_outlined,
              child: IgnorePointer(
                ignoring: isBackupBusy,
                child: AppSegmentedControl<WeightUnit>(
                  value: settings.weightUnit,
                  segments: const [
                    AppSegment(value: WeightUnit.kg, label: 'Kilograms'),
                    AppSegment(value: WeightUnit.lb, label: 'Pounds'),
                  ],
                  onChanged: (value) async {
                    await ref.read(settingsControllerProvider).saveWeightUnit(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsCard(
              title: 'Backup and restore',
              subtitle: 'Exports include plan, exercises, sessions, logs and settings. Imports validate schema version before replacing local data.',
              icon: Icons.backup_outlined,
              child: _BackupSection(
                settings: settings,
                isBusy: isBackupBusy,
                errorText: backupState.hasError
                    ? backupState.error.toString().replaceFirst('Bad state: ', '')
                    : null,
                onExport: () => _handleExportBackup(context, ref),
                onImport: () => _handleImportBackup(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExportBackup(BuildContext context, WidgetRef ref) async {
    try {
      final file = await ref.read(backupControllerProvider.notifier).exportBackup();
      if (!context.mounted) {
        return;
      }
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'SmartFit backup',
          text: 'SmartFit backup export',
        ),
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup exported: ${file.path}')),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Bad state: ', ''))),
      );
    }
  }

  Future<void> _handleImportBackup(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: false,
    );
    final filePath = result?.files.singleOrNull?.path;
    if (filePath == null || !context.mounted) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return const AppConfirmDialog(
          title: 'Replace local data?',
          description:
              'Importing a backup will replace the current local plan, exercises, sessions, logs and settings. This cannot be undone.',
          confirmLabel: 'Import backup',
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(backupControllerProvider.notifier).importBackup(filePath);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup imported successfully.')),
      );
    } on SmartFitBackupException catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Bad state: ', ''))),
      );
    }
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppInteractiveSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _BackupSection extends StatelessWidget {
  const _BackupSection({
    required this.settings,
    required this.isBusy,
    required this.errorText,
    required this.onExport,
    required this.onImport,
  });

  final AppSettings settings;
  final bool isBusy;
  final String? errorText;
  final Future<void> Function() onExport;
  final Future<void> Function() onImport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                settings.lastBackupAt == null
                    ? 'No backup exported yet'
                    : 'Last export: ${_formatDateTime(settings.lastBackupAt!)}',
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (isBusy)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Imports accept only SmartFit JSON backups with schema version ${SmartFitBackupService.currentSchemaVersion}.',
          style: theme.textTheme.bodySmall,
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            errorText!,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: AppPrimaryButton(
                label: 'Export backup',
                icon: Icons.ios_share_rounded,
                onPressed: isBusy ? null : () => onExport(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppSecondaryButton(
                label: 'Import backup',
                icon: Icons.file_open_rounded,
                onPressed: isBusy ? null : () => onImport(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
  }
}