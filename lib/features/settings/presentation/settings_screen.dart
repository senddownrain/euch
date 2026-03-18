import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(l10n.systemTheme)),
              ButtonSegment(value: ThemeMode.light, label: Text(l10n.lightTheme)),
              ButtonSegment(value: ThemeMode.dark, label: Text(l10n.darkTheme)),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (value) => controller.updateThemeMode(value.first),
          ),
          const SizedBox(height: 20),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: settings.keepScreenOn,
            onChanged: controller.updateKeepScreenOn,
            title: Text(l10n.keepScreenOn),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: settings.fontFamily,
            decoration: InputDecoration(labelText: l10n.fontFamily),
            items: [
              for (final font in AppFonts.available)
                DropdownMenuItem(value: font, child: Text(font)),
            ],
            onChanged: (value) {
              if (value != null) controller.updateFontFamily(value);
            },
          ),
          const SizedBox(height: 20),
          Text(l10n.fontSize),
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
              ButtonSegment(value: ItemListViewMode.cards, label: Text(l10n.cardView)),
              ButtonSegment(value: ItemListViewMode.compact, label: Text(l10n.compactView)),
            ],
            selected: {settings.viewMode},
            onSelectionChanged: (value) => controller.updateViewMode(value.first),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Locale>(
            value: settings.locale,
            decoration: InputDecoration(labelText: l10n.language),
            items: [
              DropdownMenuItem(value: const Locale('be'), child: Text(l10n.belarusian)),
              DropdownMenuItem(value: const Locale('ru'), child: Text(l10n.russian)),
            ],
            onChanged: (value) {
              if (value != null) controller.updateLocale(value);
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.readPreview, style: Theme.of(context).textTheme.titleMedium),
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
