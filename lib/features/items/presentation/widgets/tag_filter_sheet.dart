import 'package:flutter/material.dart';
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.tagFilterTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (tags.isEmpty)
              const Text(AppStrings.noTags)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in tags)
                    FilterChip(
                      selected: selected.contains(tag),
                      label: Text(tag),
                      onSelected: (_) => ref.read(itemFiltersProvider.notifier).toggleTag(tag),
                    ),
                ],
              ),
            const SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
