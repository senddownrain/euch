import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/share_service.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/providers.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/items_repository.dart';
import 'widgets/text_settings_sheet.dart';

class ItemViewScreen extends ConsumerWidget {
  const ItemViewScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final isAdmin = ref.watch(isAdminLoggedInProvider);
    final itemAsync = ref.watch(_singleItemProvider(itemId));

    return Scaffold(
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return EmptyState(
              title: l10n.notFound,
              subtitle: l10n.emptyItemsSubtitle,
              icon: Icons.find_in_page_outlined,
            );
          }

          final bodyStyle = Style(
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
            fontSize: FontSize(16 * settings.fontSizeMultiplier),
            lineHeight: const LineHeight(1.55),
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            wordBreak: WordBreak.breakWord,
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(item.title),
                actions: [
                  IconButton(
                    tooltip: l10n.share,
                    onPressed: () async {
                      final text = l10n.shareMessage(
                        item.title,
                        '${AppConstants.publicShareBase}${item.id}',
                      );
                      await ref.read(shareServiceProvider).shareText(text, subject: item.title);
                    },
                    icon: const Icon(Icons.share_outlined),
                  ),
                  IconButton(
                    tooltip: settings.pinnedIds.contains(item.id) ? l10n.unpin : l10n.pin,
                    onPressed: () => ref.read(settingsControllerProvider.notifier).togglePin(item.id),
                    icon: Icon(
                      settings.pinnedIds.contains(item.id)
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.textSettings,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        builder: (_) => const TextSettingsSheet(),
                      );
                    },
                    icon: const Icon(Icons.text_fields_outlined),
                  ),
                  if (isAdmin)
                    IconButton(
                      tooltip: l10n.edit,
                      onPressed: () => context.push('/item/edit/${item.id}'),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in item.tags) Chip(label: Text(tag)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Html(
                        data: HtmlUtils.sanitize(item.text),
                        style: {
                          'body': bodyStyle,
                          'p': bodyStyle,
                          'h1': bodyStyle.copyWith(
                            fontSize: FontSize(28 * settings.fontSizeMultiplier),
                            fontWeight: FontWeight.w700,
                          ),
                          'h2': bodyStyle.copyWith(
                            fontSize: FontSize(24 * settings.fontSizeMultiplier),
                            fontWeight: FontWeight.w700,
                          ),
                          'h3': bodyStyle.copyWith(
                            fontSize: FontSize(20 * settings.fontSizeMultiplier),
                            fontWeight: FontWeight.w700,
                          ),
                          'li': bodyStyle,
                          'span': bodyStyle,
                        },
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.appTitle,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (_, __) => Center(child: Text(l10n.genericError)),
        loading: () => LoadingIndicator(label: l10n.loading),
      ),
    );
  }
}

final _singleItemProvider = StreamProvider.family((ref, String itemId) {
  return ref.watch(itemsRepositoryProvider).watchItem(itemId);
});
