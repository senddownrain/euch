import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/html_utils.dart';
import '../../../core/utils/item_sorter.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../../l10n/app_localizations.dart';
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

  Future<void> _deleteItem(BuildContext context, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: l10n.confirmDeleteTitle,
      content: l10n.confirmDeleteBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.delete,
    );

    if (!confirmed || !mounted) return;

    try {
      await ref.read(itemsRepositoryProvider).deleteItem(id);
      if (mounted) {
        SnackbarHelper.show(context, l10n.deleteSuccess);
      }
    } catch (_) {
      if (mounted) {
        SnackbarHelper.show(context, l10n.genericError, isError: true);
      }
    }
  }

  Future<void> _downloadOffline(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(itemsRepositoryProvider).prefetchAll();
      if (mounted) SnackbarHelper.show(context, l10n.offlineReady);
    } catch (_) {
      if (mounted) SnackbarHelper.show(context, l10n.networkUnavailable, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(filteredItemsProvider);
    final tags = ref.watch(allTagsProvider);
    final isAdmin = ref.watch(isAdminLoggedInProvider);
    final settings = ref.watch(settingsControllerProvider);
    final selectedTags = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.search,
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ItemsSearchDelegate(l10n.searchHint),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: l10n.filters,
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
          PopupMenuButton<_HomeMenuAction>(
            onSelected: (action) async {
              switch (action) {
                case _HomeMenuAction.settings:
                  context.push('/settings');
                  return;
                case _HomeMenuAction.about:
                  context.push('/about');
                  return;
                case _HomeMenuAction.admin:
                  context.push('/admin');
                  return;
                case _HomeMenuAction.login:
                  context.push('/login');
                  return;
                case _HomeMenuAction.logout:
                  await ref.read(authRepositoryProvider).signOut();
                  if (mounted) SnackbarHelper.show(context, l10n.logoutSuccess);
                  return;
                case _HomeMenuAction.downloadOffline:
                  await _downloadOffline(context);
                  return;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _HomeMenuAction.settings,
                child: Text(l10n.settings),
              ),
              PopupMenuItem(
                value: _HomeMenuAction.about,
                child: Text(l10n.about),
              ),
              PopupMenuItem(
                value: _HomeMenuAction.downloadOffline,
                child: Text(l10n.downloadOffline),
              ),
              if (isAdmin)
                PopupMenuItem(
                  value: _HomeMenuAction.admin,
                  child: Text(l10n.admin),
                ),
              PopupMenuItem(
                value: isAdmin ? _HomeMenuAction.logout : _HomeMenuAction.login,
                child: Text(isAdmin ? l10n.logout : l10n.login),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/item/new'),
              icon: const Icon(Icons.add),
              label: Text(l10n.addItem),
            )
          : null,
      body: items.when(
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              title: l10n.emptyItemsTitle,
              subtitle: l10n.emptyItemsSubtitle,
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(itemsRepositoryProvider).prefetchAll(),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 96, top: 8),
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
                  editLabel: l10n.edit,
                  deleteLabel: l10n.delete,
                );
              },
            ),
          );
        },
        error: (_, _) => Center(child: Text(l10n.genericError)),
        loading: () => LoadingIndicator(label: l10n.loading),
      ),
    );
  }
}

enum _HomeMenuAction { settings, about, admin, login, logout, downloadOffline }

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
