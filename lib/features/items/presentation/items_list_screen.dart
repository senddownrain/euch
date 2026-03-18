import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/utils/item_sorter.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/providers.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/items_repository.dart';
import 'items_controller.dart';
import 'widgets/compact_item_row.dart';
import 'widgets/item_card.dart';
import 'widgets/tag_filter_sheet.dart';

class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _deleteItem(BuildContext context, String id) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: AppStrings.confirmDeleteTitle,
      content: AppStrings.confirmDeleteBody,
      cancelLabel: AppStrings.cancel,
      confirmLabel: AppStrings.delete,
    );

    if (!confirmed || !mounted) return;

    try {
      await ref.read(itemsRepositoryProvider).deleteItem(id);
      if (mounted) {
        SnackbarHelper.show(context, AppStrings.deleteSuccess);
      }
    } catch (_) {
      if (mounted) {
        SnackbarHelper.show(context, AppStrings.genericError, isError: true);
      }
    }
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: _ItemsSearchDelegate(AppStrings.searchHint),
    );
  }

  void _openFilters(List<String> tags) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => TagFilterSheet(tags: tags),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(filteredItemsProvider);
    final tags = ref.watch(allTagsProvider);
    final isAdmin = ref.watch(isAdminLoggedInProvider);
    final settings = ref.watch(settingsControllerProvider);
    final selectedTags = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  AppStrings.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text(AppStrings.settings),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/settings');
                },
              ),
              ExpansionTile(
                leading: const Icon(Icons.tune_outlined),
                title: const Text(AppStrings.searchAndFilters),
                childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: const Icon(Icons.search),
                    title: const Text(AppStrings.search),
                    onTap: () {
                      Navigator.of(context).pop();
                      _openSearch();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: _FilterIcon(selectedCount: selectedTags.length),
                    title: const Text(AppStrings.filters),
                    subtitle: selectedTags.isEmpty
                        ? const Text(AppStrings.filtersNotSelected)
                        : Text(AppStrings.filtersSelected(selectedTags.length)),
                    onTap: () {
                      Navigator.of(context).pop();
                      _openFilters(tags.asData?.value ?? const []);
                    },
                  ),
                ],
              ),
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: const Text(AppStrings.admin),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/admin');
                  },
                ),
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text(AppStrings.logout),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await ref.read(authRepositoryProvider).signOut();
                    if (mounted) SnackbarHelper.show(context, AppStrings.logoutSuccess);
                  },
                ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 76,
        title: const Text(
          AppStrings.appTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.menu,
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/item/new'),
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.addItem),
            )
          : null,
      body: items.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              title: AppStrings.emptyItemsTitle,
              subtitle: AppStrings.emptyItemsSubtitle,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 96, top: 12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final isPinned = settings.pinnedIds.contains(item.id);
              if (settings.viewMode == ItemListViewMode.compact) {
                return CompactItemRow(
                  item: item,
                  isPinned: isPinned,
                  isAdmin: isAdmin,
                  onTap: () => context.push('/item/${item.id}'),
                  onTogglePin: () => ref.read(settingsControllerProvider.notifier).togglePin(item.id),
                  onEdit: () => context.push('/item/edit/${item.id}'),
                  onDelete: () => _deleteItem(context, item.id),
                );
              }

              return ItemCard(
                item: item,
                isPinned: isPinned,
                isAdmin: isAdmin,
                onTap: () => context.push('/item/${item.id}'),
                onTogglePin: () => ref.read(settingsControllerProvider.notifier).togglePin(item.id),
                onEdit: () => context.push('/item/edit/${item.id}'),
                onDelete: () => _deleteItem(context, item.id),
                editLabel: AppStrings.edit,
                deleteLabel: AppStrings.delete,
              );
            },
          );
        },
        error: (_, __) => const Center(child: Text(AppStrings.genericError)),
        loading: () => const LoadingIndicator(label: AppStrings.loading),
      ),
    );
  }
}

class _ItemsSearchDelegate extends SearchDelegate<void> {
  _ItemsSearchDelegate(this.hint);

  final String hint;

  @override
  String get searchFieldLabel => hint;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final items = ref.watch(allItemsProvider);
        final selectedTags = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));
        final pinnedIds = ref.watch(settingsControllerProvider.select((value) => value.pinnedIds));

        return items.when(
          data: (list) {
            final normalizedQuery = query.trim().toLowerCase();
            final filtered = list.where((item) {
              final matchesQuery = normalizedQuery.isEmpty ||
                  item.title.toLowerCase().contains(normalizedQuery) ||
                  HtmlUtils.stripHtml(item.text).toLowerCase().contains(normalizedQuery);
              final matchesTags = selectedTags.isEmpty ||
                  selectedTags.every((tag) => item.tags.contains(tag));
              return matchesQuery && matchesTags;
            }).toList();
            final sorted = ItemSorter.sort(filtered, pinnedIds);

            return ListView(
              children: [
                for (final item in sorted)
                  ListTile(
                    title: Text(item.title),
                    subtitle: Text(
                      item.tags.join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      close(context, null);
                      context.push('/item/${item.id}');
                    },
                  ),
              ],
            );
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const LoadingIndicator(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class _FilterIcon extends StatelessWidget {
  const _FilterIcon({required this.selectedCount});

  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.filter_alt_outlined),
        if (selectedCount > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                selectedCount.toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
