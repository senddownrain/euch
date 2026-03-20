import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import 'app_logo.dart';

class BrandAppBarTitle extends StatelessWidget {
  const BrandAppBarTitle({
    super.key,
    this.subtitle,
    this.compact = false,
  });

  final String? subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(
          size: compact ? 20 : 22,
          padding: EdgeInsets.all(compact ? 5 : 6),
          backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.34),
          borderColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.18),
        ),
        SizedBox(width: compact ? 10 : 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: compact
                    ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
                    : theme.textTheme.titleLarge?.copyWith(fontSize: 21),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
