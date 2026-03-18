import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
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
  _OfflineSyncStatus _offlineSyncStatus = _OfflineSyncStatus.syncing;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncOffline();
    });
  }

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
    if (mounted) {
      setState(() => _offlineSyncStatus = _OfflineSyncStatus.syncing);
    }
    try {
      await ref.read(itemsRepositoryProvider).prefetchAll();
      if (!mounted) return;
      setState(() => _offlineSyncStatus = _OfflineSyncStatus.ready);
      if (showFeedback) {
        SnackbarHelper.show(context, AppStrings.offlineReady);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _offlineSyncStatus = _OfflineSyncStatus.error);
      if (showFeedback) {
        SnackbarHelper.show(context, AppStrings.networkUnavailable, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(filteredItemsProvider);
    final tags = ref.watch(allTagsProvider);
    final isAdmin = ref.watch(isAdminLoggedInProvider);
    final settings = ref.watch(settingsControllerProvider);
    final selectedTags = ref.watch(itemFiltersProvider.select((value) => value.selectedTags));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        title: const Text(
          AppStrings.appTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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
                delegate: _ItemsSearchDelegate(ref, AppStrings.searchHint),
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
          PopupMenuButton<_HomeMenuAction>(
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
              PopupMenuItem(
                value: _HomeMenuAction.settings,
                child: const Text(AppStrings.settings),
              ),
              PopupMenuItem(
                value: _HomeMenuAction.refreshDatabase,
                child: const Text(AppStrings.updateDatabase),
              ),
              if (isAdmin)
                PopupMenuItem(
                  value: _HomeMenuAction.admin,
                  child: const Text(AppStrings.admin),
                ),
              if (isAdmin)
                PopupMenuItem(
                  value: _HomeMenuAction.logout,
                  child: const Text(AppStrings.logout),
                ),
            ],
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
                  editLabel: AppStrings.edit,
                  deleteLabel: AppStrings.delete,
                );
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

enum _HomeMenuAction { settings, admin, logout, refreshDatabase }

enum _OfflineSyncStatus {
  syncing(Icons.cloud_sync_outlined, AppStrings.offlineStatusSyncing),
  ready(Icons.cloud_done_outlined, AppStrings.offlineStatusReady),
  error(Icons.cloud_off_outlined, AppStrings.offlineStatusError);

  const _OfflineSyncStatus(this.icon, this.label);

  final IconData icon;
  final String label;

  Color color(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (this) {
      _OfflineSyncStatus.syncing => scheme.primary,
      _OfflineSyncStatus.ready => Colors.green,
      _OfflineSyncStatus.error => scheme.error,
    };
  }
}

class _ItemsSearchDelegate extends SearchDelegate<void> {
  _ItemsSearchDelegate(this.ref, this.hint);

  final WidgetRef ref;
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
            ref.read(itemFiltersProvider.notifier).setSearchQuery('');
          },
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        ref.read(itemFiltersProvider.notifier).setSearchQuery('');
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ref.read(itemFiltersProvider.notifier).setSearchQuery(query);
    return Consumer(
      builder: (context, ref, _) {
        final items = ref.watch(filteredItemsProvider);
        return items.when(
          data: (list) => ListView(
            children: [
              for (final item in list)
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
          ),
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const LoadingIndicator(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ref.read(itemFiltersProvider.notifier).setSearchQuery(query);
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
