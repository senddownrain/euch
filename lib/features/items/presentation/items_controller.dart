import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/item.dart';
import '../../../core/utils/item_sorter.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/items_repository.dart';
import '../domain/item_filters.dart';

final itemFiltersProvider = NotifierProvider<ItemFiltersController, ItemFilters>(
  ItemFiltersController.new,
);

class ItemFiltersController extends Notifier<ItemFilters> {
  @override
  ItemFilters build() => const ItemFilters();

  void toggleTag(String tag) {
    final next = {...state.selectedTags};
    if (!next.add(tag)) {
      next.remove(tag);
    }
    state = state.copyWith(selectedTags: next);
  }

  void clearTags() {
    state = state.copyWith(selectedTags: <String>{});
  }
}

final allItemsProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(itemsRepositoryProvider).watchItems();
});

final filteredItemsProvider = Provider<AsyncValue<List<Item>>>((ref) {
  final items = ref.watch(allItemsProvider);
  final filters = ref.watch(itemFiltersProvider);
  final pinnedIds = ref.watch(settingsControllerProvider.select((value) => value.pinnedIds));

  return items.whenData((list) {
    final filtered = list.where((item) {
      final matchesTags = filters.selectedTags.isEmpty ||
          filters.selectedTags.every((tag) => item.tags.contains(tag));
      return matchesTags;
    }).toList();

    return ItemSorter.sort(filtered, pinnedIds);
  });
});

final allTagsProvider = Provider<AsyncValue<List<String>>>((ref) {
  final items = ref.watch(allItemsProvider);
  return items.whenData((list) {
    final tags = <String>{};
    for (final item in list) {
      tags.addAll(item.tags);
    }
    final sorted = tags.toList()..sort();
    return sorted;
  });
});

String generateItemId() {
  final random = Random();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final suffix = random.nextInt(999999).toString().padLeft(6, '0');
  return 'item_${timestamp}_$suffix';
}
