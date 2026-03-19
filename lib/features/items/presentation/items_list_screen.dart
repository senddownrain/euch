import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final theme = Theme.of(context);
    final items = ref.watch(filteredItemsProvider);
    final tags = ref.watch(allTagsProvider);
    final isAdmin = ref.watch(isAdminLoggedInProvider);
    final settings = ref.watch(settingsControllerProvider);
    final selectedTags = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.72),
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.itemsCount(items.asData?.value.length ?? 0),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Tooltip(
              message: _offlineSyncStatus.label,
              child: Icon(
                _offlineSyncStatus.icon,
                color: _offlineSyncStatus.color(context),
              ),
            ),
          ),
          IconButton(
            tooltip: AppStrings.search,
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ItemsSearchDelegate(AppStrings.searchHint),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: AppStrings.filters,
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (_) => TagFilterSheet(
                  tags: tags.asData?.value ?? const [],
                ),
              );
            },
            icon: _FilterIcon(selectedCount: selectedTags.length),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<_HomeMenuAction>(
              position: PopupMenuPosition.under,
              onSelected: (action) async {
                switch (action) {
                  case _HomeMenuAction.settings:
                    context.push('/settings');
                    return;
                  case _HomeMenuAction.admin:
                    context.push('/admin');
                    return;
                  case _HomeMenuAction.logout:
                    await ref.read(authRepositoryProvider).signOut();
                    if (mounted) SnackbarHelper.show(context, AppStrings.logoutSuccess);
                    return;
                  case _HomeMenuAction.refreshDatabase:
                    await _syncOffline(showFeedback: true);
                    return;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _HomeMenuAction.settings,
                  child: Text(AppStrings.settings),
                ),
                const PopupMenuItem(
                  value: _HomeMenuAction.refreshDatabase,
                  child: Text(AppStrings.updateDatabase),
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
            ),
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

          return RefreshIndicator(
            onRefresh: () => _syncOffline(showFeedback: true),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 112, top: 12),
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
