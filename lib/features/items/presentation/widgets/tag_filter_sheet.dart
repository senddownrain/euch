import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.tagFilterTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(AppStrings.settingsFilterSubtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            if (tags.isEmpty)
              const Text(AppStrings.noTags)
            else
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: [
                  for (final tag in tags)
                    FilterChip(
                      selected: selected.contains(tag),
                      label: Text(tag),
                      onSelected: (_) => ref.read(itemFiltersProvider.notifier).toggleTag(tag),
                    ),
                ],
              ),
            const SizedBox(height: 24),
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
            .slideY(begin: 0.08, end: 0, duration: 220.ms, curve: Curves.easeOutCubic),
      ),
    );
  }
}
