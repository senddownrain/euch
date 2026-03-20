import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../settings/presentation/settings_controller.dart';

class TextSettingsSheet extends ConsumerWidget {
  const TextSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 22 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppLogo(
                  size: 20,
                  padding: const EdgeInsets.all(5),
                  backgroundColor: scheme.primaryContainer.withValues(alpha: 0.34),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(AppStrings.textSettings, style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.22)),
              ),
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
                ],
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.06, end: 0, duration: 220.ms, curve: Curves.easeOutCubic),
      ),
    );
  }
}
