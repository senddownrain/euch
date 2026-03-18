import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../items_controller.dart';

class TagFilterSheet extends ConsumerWidget {
  const TagFilterSheet({
    super.key,
    required this.tags,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.tagFilterTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (tags.isEmpty)
              Text(l10n.noTags)
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
                  child: Text(l10n.clear),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.apply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
