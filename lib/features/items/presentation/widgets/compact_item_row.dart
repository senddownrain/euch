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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isPinned
            ? scheme.primaryContainer.withValues(alpha: 0.28)
            : scheme.surface.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          title: Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(height: 1.2),
          ),
          subtitle: item.tags.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    item.tags.join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
          trailing: Wrap(
            spacing: 2,
            children: [
              IconButton(
                onPressed: onTogglePin,
                icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              ),
              if (isAdmin) ...[
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
