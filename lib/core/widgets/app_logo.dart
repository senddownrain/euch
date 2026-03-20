import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 40,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
    this.borderColor,
  });

  static const assetPath = 'lib/assets/icon.png';

  final double size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(size * 0.42),
        border: Border.all(
          color: borderColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
