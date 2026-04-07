import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/layouts/app_page_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_secondary_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = 'settings';
  static const routePath = '/settings';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPageScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Theme, units and backup shell', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This phase defines the visual and navigational structure of settings before the real persistence screens are connected.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      child: ListView(
        children: const [
          _SettingsCard(
            title: 'Appearance',
            subtitle: 'Theme mode defaults to system and can later expose light/dark override.',
            icon: Icons.contrast_outlined,
          ),
          SizedBox(height: AppSpacing.lg),
          _SettingsCard(
            title: 'Training units',
            subtitle: 'Weight unit defaults to kg and stays explicit in all training inputs.',
            icon: Icons.monitor_weight_outlined,
          ),
          SizedBox(height: AppSpacing.lg),
          _SettingsCard(
            title: 'Backup and restore',
            subtitle: 'Export and import actions belong here once the feature wiring is added in later phases.',
            icon: Icons.backup_outlined,
            showActions: true,
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.showActions = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool showActions;

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
          if (showActions) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppSecondaryButton(label: 'Export backup', onPressed: () {}),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppSecondaryButton(label: 'Import backup', onPressed: () {}),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}