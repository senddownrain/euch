import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../settings/presentation/settings_controller.dart';

class TextSettingsSheet extends ConsumerWidget {
  const TextSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 28 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.textSettings, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(AppStrings.settingsReadingSubtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
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
            Text(AppStrings.fontSize, style: theme.textTheme.titleMedium),
            Slider(
              value: settings.fontSizeMultiplier,
              min: 0.8,
              max: 1.8,
              divisions: 10,
              label: settings.fontSizeMultiplier.toStringAsFixed(1),
              onChanged: controller.updateFontSize,
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.08, end: 0, duration: 220.ms, curve: Curves.easeOutCubic),
      ),
    );
  }
}
