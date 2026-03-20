import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_logo.dart';
import '../items_controller.dart';

class TagFilterSheet extends ConsumerWidget {
  const TagFilterSheet({
    super.key,
    required this.tags,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));
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
                  size: 18,
                  padding: const EdgeInsets.all(5),
                  backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.34),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(AppStrings.tagFilterTitle, style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.2)),
              ),
              child: tags.isEmpty
                  ? const Text(AppStrings.noTags)
                  : Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        for (final tag in tags)
                          FilterChip(
                            selected: selected.contains(tag),
                            label: Text(tag),
                            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onSelected: (_) => ref.read(itemFiltersProvider.notifier).toggleTag(tag),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => ref.read(itemFiltersProvider.notifier).clearTags(),
                  child: const Text(AppStrings.clear),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.apply),
                ),
              ],
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
