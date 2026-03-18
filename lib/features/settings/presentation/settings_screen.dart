import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
