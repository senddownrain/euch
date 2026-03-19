import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/presentation/providers.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/items_repository.dart';
import 'widgets/text_settings_sheet.dart';

class ItemViewScreen extends ConsumerWidget {
  const ItemViewScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final isAdmin = ref.watch(isAdminLoggedInProvider);
    final itemAsync = ref.watch(_singleItemProvider(itemId));
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return const EmptyState(
              title: AppStrings.notFound,
              subtitle: AppStrings.emptyItemsSubtitle,
              icon: Icons.find_in_page_outlined,
            );
          }

          final bodyTextStyle = AppTheme.readingBodyStyle(
            context,
            fontFamily: settings.fontFamily,
            multiplier: settings.fontSizeMultiplier,
            color: scheme.onSurface.withValues(alpha: 0.92),
          );
          final headingStyle = AppTheme.readingTitleStyle(
            context,
            fontFamily: settings.fontFamily,
            multiplier: settings.fontSizeMultiplier,
            color: scheme.onSurface,
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 96,
                backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.76),
                surfaceTintColor: Colors.transparent,
                title: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
                ),
                actions: [
                  IconButton(
                    tooltip: AppStrings.textSettings,
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
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        tooltip: AppStrings.edit,
                        onPressed: () => context.push('/item/edit/${item.id}'),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.surface.withValues(alpha: 0.82),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: scheme.outlineVariant.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: headingStyle.copyWith(
                                  fontSize: headingStyle.fontSize! * 1.08,
                                ),
                              ),
                              if (item.tags.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final tag in item.tags) Chip(label: Text(tag)),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 24),
                              Html(
                                data: HtmlUtils.sanitize(item.text),
                                style: {
                                  'body': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.72),
                                    letterSpacing: bodyTextStyle.letterSpacing,
                                    color: bodyTextStyle.color,
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                  ),
                                  'p': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.72),
                                    letterSpacing: bodyTextStyle.letterSpacing,
                                    color: bodyTextStyle.color,
                                    margin: Margins.only(bottom: 20),
                                    padding: HtmlPaddings.zero,
                                  ),
                                  'h1': Style(
                                    fontFamily: headingStyle.fontFamily,
                                    fontSize: FontSize((headingStyle.fontSize ?? 30) * 1.18),
                                    fontWeight: FontWeight.w600,
                                    lineHeight: const LineHeight(1.26),
                                    color: headingStyle.color,
                                    margin: Margins.only(top: 28, bottom: 16),
                                  ),
                                  'h2': Style(
                                    fontFamily: headingStyle.fontFamily,
                                    fontSize: FontSize((headingStyle.fontSize ?? 28) * 1.04),
                                    fontWeight: FontWeight.w600,
                                    lineHeight: const LineHeight(1.28),
                                    color: headingStyle.color,
                                    margin: Margins.only(top: 26, bottom: 14),
                                  ),
                                  'h3': Style(
                                    fontFamily: headingStyle.fontFamily,
                                    fontSize: FontSize((headingStyle.fontSize ?? 24) * 0.92),
                                    fontWeight: FontWeight.w600,
                                    lineHeight: const LineHeight(1.3),
                                    color: headingStyle.color,
                                    margin: Margins.only(top: 22, bottom: 12),
                                  ),
                                  'li': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.72),
                                    margin: Margins.only(bottom: 12),
                                    color: bodyTextStyle.color,
                                  ),
                                  'blockquote': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize((bodyTextStyle.fontSize ?? 18) * 0.98),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.72),
                                    color: scheme.onSurfaceVariant,
                                    backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.26),
                                    padding: HtmlPaddings.all(16),
                                    margin: Margins.only(top: 18, bottom: 18),
                                  ),
                                  'span': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.72),
                                    color: bodyTextStyle.color,
                                  ),
                                },
                              ),
                              const SizedBox(height: 32),
                              Center(
                                child: Text(
                                  AppStrings.appTitle,
                                  style: theme.textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 280.ms, curve: Curves.easeOut)
                      .move(begin: const Offset(0, 12), end: Offset.zero, duration: 280.ms),
                ),
              ),
            ],
          );
        },
        error: (_, __) => const Center(child: Text(AppStrings.genericError)),
        loading: () => const LoadingIndicator(label: AppStrings.loading),
      ),
    );
  }
}

final _singleItemProvider = StreamProvider.family((ref, String itemId) {
  return ref.watch(itemsRepositoryProvider).watchItem(itemId);
});
