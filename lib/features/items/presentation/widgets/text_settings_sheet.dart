import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/settings_controller.dart';

class TextSettingsSheet extends ConsumerWidget {
  const TextSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.textSettings, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(l10n.fontFamily),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: settings.fontFamily,
              items: [
                for (final font in AppFonts.available)
                  DropdownMenuItem(value: font, child: Text(font)),
              ],
              onChanged: (value) {
                if (value != null) controller.updateFontFamily(value);
              },
            ),
            const SizedBox(height: 16),
            Text(l10n.fontSize),
            Slider(
              value: settings.fontSizeMultiplier,
              min: 0.8,
              max: 1.8,
              divisions: 10,
              label: settings.fontSizeMultiplier.toStringAsFixed(1),
              onChanged: controller.updateFontSize,
            ),
          ],
        ),
      ),
    );
  }
}
