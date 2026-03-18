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
    return ListTile(
      onTap: onTap,
      minTileHeight: 72,
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      trailing: Wrap(
        spacing: 6,
        children: [
          IconButton(
            onPressed: onTogglePin,
            iconSize: 24,
            splashRadius: 24,
            icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
          ),
          if (isAdmin) ...[
            IconButton(
              onPressed: onEdit,
              iconSize: 24,
              splashRadius: 24,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: onDelete,
              iconSize: 24,
              splashRadius: 24,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ],
      ),
    );
  }
}
