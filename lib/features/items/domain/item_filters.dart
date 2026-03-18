class ItemFilters {
  const ItemFilters({
    this.searchQuery = '',
    this.selectedTags = const <String>{},
  });

  final String searchQuery;
  final Set<String> selectedTags;

  ItemFilters copyWith({
    String? searchQuery,
    Set<String>? selectedTags,
  }) {
    return ItemFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }
}
