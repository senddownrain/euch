import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/item.dart';
import '../../../../core/utils/html_utils.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.isPinned,
    required this.isAdmin,
    required this.onTap,
    required this.onTogglePin,
    this.onEdit,
    this.onDelete,
    required this.editLabel,
    required this.deleteLabel,
  });

  final Item item;
  final bool isPinned;
  final bool isAdmin;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String editLabel;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final preview = HtmlUtils.preview(item.text);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: isPinned
                ? Border(
                    left: BorderSide(
                      color: scheme.secondary.withValues(alpha: 0.6),
                      width: 3,
                    ),
                  )
                : null,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isPinned
                    ? scheme.secondaryContainer.withValues(alpha: 0.34)
                    : scheme.surface.withValues(alpha: 0.98),
                scheme.surface.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isPinned)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: scheme.secondaryContainer.withValues(alpha: 0.64),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                AppStrings.pinned,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: scheme.secondary,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          Text(
                            item.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              height: 1.2,
                              letterSpacing: -0.32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: onTogglePin,
                      constraints: const BoxConstraints.tightFor(width: 38, height: 38),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.46),
                      ),
                      icon: Icon(
                        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    preview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.55,
                    ),
                  ),
                ],
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
                if (isAdmin) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(editLabel),
                      ),
                      const SizedBox(width: 2),
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: Text(deleteLabel),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
