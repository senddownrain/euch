import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/widgets/app_logo.dart';
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
                expandedHeight: 84,
                backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.78),
                surfaceTintColor: Colors.transparent,
                titleSpacing: 16,
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
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
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: scheme.outlineVariant.withValues(alpha: 0.24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.shadow.withValues(alpha: 0.03),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppLogo(
                                    size: 22,
                                    padding: const EdgeInsets.all(5),
                                    backgroundColor: scheme.primaryContainer.withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      AppStrings.appTitle,
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                item.title,
                                style: headingStyle.copyWith(
                                  fontSize: headingStyle.fontSize! * 1.02,
                                ),
                              ),
                              if (item.tags.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    for (final tag in item.tags)
                                      Chip(
                                        label: Text(tag),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                                      ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 18),
                              Html(
                                data: HtmlUtils.sanitize(item.text),
                                style: {
                                  'body': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.74),
                                    letterSpacing: bodyTextStyle.letterSpacing,
                                    color: bodyTextStyle.color,
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                  ),
                                  'p': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.74),
                                    letterSpacing: bodyTextStyle.letterSpacing,
                                    color: bodyTextStyle.color,
                                    margin: Margins.only(bottom: 16),
                                    padding: HtmlPaddings.zero,
                                  ),
                                  'h1': Style(
                                    fontFamily: headingStyle.fontFamily,
                                    fontSize: FontSize((headingStyle.fontSize ?? 30) * 1.12),
                                    fontWeight: FontWeight.w600,
                                    lineHeight: const LineHeight(1.22),
                                    color: headingStyle.color,
                                    margin: Margins.only(top: 24, bottom: 12),
                                  ),
                                  'h2': Style(
                                    fontFamily: headingStyle.fontFamily,
                                    fontSize: FontSize((headingStyle.fontSize ?? 28) * 1.0),
                                    fontWeight: FontWeight.w600,
                                    lineHeight: const LineHeight(1.24),
                                    color: headingStyle.color,
                                    margin: Margins.only(top: 22, bottom: 10),
                                  ),
                                  'h3': Style(
                                    fontFamily: headingStyle.fontFamily,
                                    fontSize: FontSize((headingStyle.fontSize ?? 24) * 0.9),
                                    fontWeight: FontWeight.w600,
                                    lineHeight: const LineHeight(1.28),
                                    color: headingStyle.color,
                                    margin: Margins.only(top: 18, bottom: 10),
                                  ),
                                  'li': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.74),
                                    margin: Margins.only(bottom: 8),
                                    color: bodyTextStyle.color,
                                  ),
                                  'blockquote': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize((bodyTextStyle.fontSize ?? 18) * 0.98),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.74),
                                    color: scheme.onSurfaceVariant,
                                    backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.22),
                                    padding: HtmlPaddings.all(14),
                                    margin: Margins.only(top: 14, bottom: 14),
                                  ),
                                  'span': Style(
                                    fontFamily: bodyTextStyle.fontFamily,
                                    fontSize: FontSize(bodyTextStyle.fontSize ?? 18),
                                    lineHeight: LineHeight(bodyTextStyle.height ?? 1.74),
                                    color: bodyTextStyle.color,
                                  ),
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppLogo(
                                    size: 14,
                                    padding: const EdgeInsets.all(4),
                                    backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.26),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppStrings.appTitle,
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 280.ms, curve: Curves.easeOut)
                      .move(begin: const Offset(0, 10), end: Offset.zero, duration: 280.ms),
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
