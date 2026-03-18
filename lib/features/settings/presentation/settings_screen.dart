import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../items/data/items_repository.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  _OfflineSyncStatus _offlineSyncStatus = _OfflineSyncStatus.idle;

  Future<void> _syncOffline() async {
    if (mounted) {
      setState(() => _offlineSyncStatus = _OfflineSyncStatus.syncing);
    }
    try {
      await ref.read(itemsRepositoryProvider).prefetchAll();
      if (!mounted) return;
      setState(() => _offlineSyncStatus = _OfflineSyncStatus.ready);
      SnackbarHelper.show(context, AppStrings.offlineReady);
    } catch (_) {
      if (!mounted) return;
      setState(() => _offlineSyncStatus = _OfflineSyncStatus.error);
      SnackbarHelper.show(context, AppStrings.networkUnavailable, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.databaseSectionTitle, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _offlineSyncStatus.icon,
                        color: _offlineSyncStatus.color(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_offlineSyncStatus.label)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _offlineSyncStatus == _OfflineSyncStatus.syncing ? null : _syncOffline,
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text(AppStrings.updateDatabase),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(AppStrings.systemTheme)),
              ButtonSegment(value: ThemeMode.light, label: Text(AppStrings.lightTheme)),
              ButtonSegment(value: ThemeMode.dark, label: Text(AppStrings.darkTheme)),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (value) => controller.updateThemeMode(value.first),
          ),
          const SizedBox(height: 20),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: settings.keepScreenOn,
            onChanged: controller.updateKeepScreenOn,
            title: const Text(AppStrings.keepScreenOn),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 20),
          const Text(AppStrings.fontSize),
          Slider(
            value: settings.fontSizeMultiplier,
            min: 0.8,
            max: 1.8,
            divisions: 10,
            label: settings.fontSizeMultiplier.toStringAsFixed(1),
            onChanged: controller.updateFontSize,
          ),
          const SizedBox(height: 12),
          SegmentedButton<ItemListViewMode>(
            segments: [
              ButtonSegment(value: ItemListViewMode.cards, label: Text(AppStrings.cardView)),
              ButtonSegment(value: ItemListViewMode.compact, label: Text(AppStrings.compactView)),
            ],
            selected: {settings.viewMode},
            onSelectionChanged: (value) => controller.updateViewMode(value.first),
          ),
          const SizedBox(height: 24),
          Text(AppStrings.readPreview, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Госпадзе, навучы нас маліцца і заставацца ў цішыні Тваёй прысутнасці.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) *
                          settings.fontSizeMultiplier,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _OfflineSyncStatus {
  idle(Icons.info_outline, AppStrings.offlineStatusIdle),
  syncing(Icons.cloud_sync_outlined, AppStrings.offlineStatusSyncing),
  ready(Icons.cloud_done_outlined, AppStrings.offlineStatusReady),
  error(Icons.cloud_off_outlined, AppStrings.offlineStatusError);

  const _OfflineSyncStatus(this.icon, this.label);

  final IconData icon;
  final String label;

  Color color(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (this) {
      _OfflineSyncStatus.idle => scheme.onSurfaceVariant,
      _OfflineSyncStatus.syncing => scheme.primary,
      _OfflineSyncStatus.ready => Colors.green,
      _OfflineSyncStatus.error => scheme.error,
    };
  }
}
