import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/brand_app_bar_title.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../items/data/items_repository.dart';
import '../../items/presentation/offline_sync_status.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  OfflineSyncStatus _offlineSyncStatus = OfflineSyncStatus.idle;

  Future<void> _syncOffline() async {
    if (mounted) {
      setState(() => _offlineSyncStatus = OfflineSyncStatus.syncing);
    }
    try {
      await ref.read(itemsRepositoryProvider).prefetchAll();
      if (!mounted) return;
      setState(() => _offlineSyncStatus = OfflineSyncStatus.ready);
      SnackbarHelper.show(context, AppStrings.offlineReady);
    } catch (_) {
      if (!mounted) return;
      setState(() => _offlineSyncStatus = OfflineSyncStatus.error);
      SnackbarHelper.show(context, AppStrings.networkUnavailable, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final previewStyle = AppTheme.readingBodyStyle(
      context,
      fontFamily: settings.fontFamily,
      multiplier: settings.fontSizeMultiplier,
    );

    return Scaffold(
      appBar: AppBar(
        title: const BrandAppBarTitle(
          compact: true,
          subtitle: AppStrings.settings,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
        children: [
          _SettingsSection(
            title: AppStrings.settingsAppearance,
            subtitle: AppStrings.settingsAppearanceSubtitle,
            child: Column(
              children: [
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.system, label: Text(AppStrings.systemTheme)),
                    ButtonSegment(value: ThemeMode.light, label: Text(AppStrings.lightTheme)),
                    ButtonSegment(value: ThemeMode.dark, label: Text(AppStrings.darkTheme)),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (value) => controller.updateThemeMode(value.first),
                ),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  value: settings.keepScreenOn,
                  onChanged: controller.updateKeepScreenOn,
                  title: const Text(AppStrings.keepScreenOn),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: AppStrings.textSettings,
            subtitle: AppStrings.settingsReadingSubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: settings.fontFamily,
                  decoration: const InputDecoration(labelText: AppStrings.fontFamily),
                  items: [
                    for (final font in AppFonts.available)
                      DropdownMenuItem(value: font, child: Text(font)),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.updateFontFamily(value);
                  },
                ),
                const SizedBox(height: 16),
                Text(AppStrings.fontSize, style: theme.textTheme.titleMedium),
                Slider(
                  value: settings.fontSizeMultiplier,
                  min: 0.8,
                  max: 1.8,
                  divisions: 10,
                  label: settings.fontSizeMultiplier.toStringAsFixed(1),
                  onChanged: controller.updateFontSize,
                ),
                Text(
                  '${AppStrings.fontSize}: ×${settings.fontSizeMultiplier.toStringAsFixed(1)}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                SegmentedButton<ItemListViewMode>(
                  segments: const [
                    ButtonSegment(value: ItemListViewMode.cards, label: Text(AppStrings.cardView)),
                    ButtonSegment(value: ItemListViewMode.compact, label: Text(AppStrings.compactView)),
                  ],
                  selected: {settings.viewMode},
                  onSelectionChanged: (value) => controller.updateViewMode(value.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: AppStrings.databaseSectionTitle,
            subtitle: AppStrings.databaseSectionSubtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _offlineSyncStatus.icon,
                        color: _offlineSyncStatus.color(context),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _offlineSyncStatus.label,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _offlineSyncStatus == OfflineSyncStatus.syncing ? null : _syncOffline,
                  icon: const Icon(Icons.download_for_offline_outlined),
                  label: const Text(AppStrings.updateDatabase),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: AppStrings.readPreview,
            subtitle: AppStrings.settingsPreviewSubtitle,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.previewHeading,
                    style: AppTheme.readingTitleStyle(
                      context,
                      fontFamily: settings.fontFamily,
                      multiplier: settings.fontSizeMultiplier,
                      scale: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Госпадзе, навучы нас маліцца і заставацца ў цішыні Тваёй прысутнасці.',
                    style: previewStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
