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
      title: Text(item.title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
    );
  }
}
