import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/utils/item_sorter.dart';
import '../../../core/widgets/brand_app_bar_title.dart';
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

enum _HomeMenuAction { search, filters, settings, admin, logout }

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
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

  Future<void> _syncOffline({bool showFeedback = false}) async {
    try {
      await ref.read(itemsRepositoryProvider).prefetchAll();
      if (!mounted) return;
      if (showFeedback) {
        SnackbarHelper.show(context, AppStrings.offlineReady);
      }
    } catch (_) {
      if (!mounted) return;
      if (showFeedback) {
        SnackbarHelper.show(context, AppStrings.networkUnavailable, isError: true);
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
    final theme = Theme.of(context);
    final items = ref.watch(filteredItemsProvider);
    final tags = ref.watch(allTagsProvider);
    final isAdmin = ref.watch(isAdminLoggedInProvider);
    final settings = ref.watch(settingsControllerProvider);
    final selectedTags = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));
    final availableTags = tags.asData?.value ?? const <String>[];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.78),
        surfaceTintColor: Colors.transparent,
        title: const BrandAppBarTitle(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<_HomeMenuAction>(
              tooltip: AppStrings.menu,
              position: PopupMenuPosition.under,
              onSelected: (action) async {
                switch (action) {
                  case _HomeMenuAction.search:
                    _openSearch();
                    return;
                  case _HomeMenuAction.filters:
                    _openFilters(availableTags);
                    return;
                  case _HomeMenuAction.settings:
                    if (mounted) context.push('/settings');
                    return;
                  case _HomeMenuAction.admin:
                    if (mounted) context.push('/admin');
                    return;
                  case _HomeMenuAction.logout:
                    await ref.read(authRepositoryProvider).signOut();
                    if (mounted) {
                      SnackbarHelper.show(context, AppStrings.logoutSuccess);
                    }
                    return;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _HomeMenuAction.search,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.search),
                    title: Text(AppStrings.search),
                  ),
                ),
                PopupMenuItem(
                  value: _HomeMenuAction.filters,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: _FilterIcon(selectedCount: selectedTags.length),
                    title: const Text(AppStrings.filters),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: _HomeMenuAction.settings,
                  child: Text(AppStrings.settings),
                ),
                if (isAdmin)
                  const PopupMenuItem(
                    value: _HomeMenuAction.admin,
                    child: Text(AppStrings.admin),
                  ),
                if (isAdmin)
                  const PopupMenuItem(
                    value: _HomeMenuAction.logout,
                    child: Text(AppStrings.logout),
                  ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
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
            return RefreshIndicator(
              onRefresh: () => _syncOffline(showFeedback: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 84),
                  EmptyState(
                    title: AppStrings.emptyItemsTitle,
                    subtitle: AppStrings.emptyItemsSubtitle,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _syncOffline(showFeedback: true),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 104, top: 8),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                final isPinned = settings.pinnedIds.contains(item.id);
                final card = settings.viewMode == ItemListViewMode.compact
                    ? CompactItemRow(
                        item: item,
                        isPinned: isPinned,
                        isAdmin: isAdmin,
                        onTap: () => context.push('/item/${item.id}'),
                        onTogglePin: () => ref.read(settingsControllerProvider.notifier).togglePin(item.id),
                        onEdit: () => context.push('/item/edit/${item.id}'),
                        onDelete: () => _deleteItem(context, item.id),
                      )
                    : ItemCard(
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

                final delayMs = (index * 40).clamp(0, 360).toInt();

                return card
                    .animate()
                    .fadeIn(
                      duration: 260.ms,
                      delay: Duration(milliseconds: delayMs),
                    )
                    .slideY(begin: 0.06, end: 0, duration: 260.ms, curve: Curves.easeOutCubic);
              },
            ),
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                for (final item in sorted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(18),
                      child: ListTile(
                        title: Text(item.title),
                        onTap: () {
                          close(context, null);
                          context.push('/item/${item.id}');
                        },
                      ),
                    ),
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
