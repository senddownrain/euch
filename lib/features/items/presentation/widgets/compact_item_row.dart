import 'package:flutter/material.dart';

import '../../../../core/models/item.dart';

class CompactItemRow extends StatelessWidget {
  const CompactItemRow({
    super.key,
    required this.item,
    required this.isPinned,
    required this.isAdmin,
    required this.onTap,
    required this.onTogglePin,
    this.onEdit,
    this.onDelete,
  });

  final Item item;
  final bool isPinned;
  final bool isAdmin;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Material(
        color: isPinned
            ? scheme.secondaryContainer.withValues(alpha: 0.34)
            : scheme.surface.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.2)),
        ),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          minTileHeight: 62,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          title: Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(height: 1.18),
          ),
          subtitle: item.tags.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item.tags.join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
          trailing: Wrap(
            spacing: 0,
            children: [
              IconButton(
                onPressed: onTogglePin,
                visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined, size: 19),
              ),
              if (isAdmin) ...[
                IconButton(
                  onPressed: onEdit,
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  icon: const Icon(Icons.edit_outlined, size: 19),
                ),
                IconButton(
                  onPressed: onDelete,
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  icon: const Icon(Icons.delete_outline, size: 19),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
