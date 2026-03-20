import '../models/item.dart';

class ItemSorter {
  const ItemSorter._();

  static List<Item> sort(List<Item> items, List<String> pinnedIds) {
    final pinned = <Item>[];
    final regular = <Item>[];

    for (final item in items) {
      if (pinnedIds.contains(item.id)) {
        pinned.add(item);
      } else {
        regular.add(item);
      }
    }

    int byDate(Item a, Item b) {
      final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return left.compareTo(right);
    }

    pinned.sort(byDate);
    regular.sort(byDate);
    return [...pinned, ...regular];
  }
}
