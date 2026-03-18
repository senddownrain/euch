class ItemFilters {
  const ItemFilters({
    this.selectedTags = const <String>{},
  });

  final Set<String> selectedTags;

  ItemFilters copyWith({
    Set<String>? selectedTags,
  }) {
    return ItemFilters(
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }
}
