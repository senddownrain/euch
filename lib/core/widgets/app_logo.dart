import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 40,
    this.padding = const EdgeInsets.all(0),
    this.backgroundColor,
    this.borderColor,
    this.imageScale = 1.24,
  });

  static const _lightAssetPath = 'lib/assets/logo_light.png';
  static const _darkAssetPath = 'lib/assets/logo_dark.png';

  final double size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double imageScale;

  static String assetPathForTheme(Brightness brightness) {
    return brightness == Brightness.dark ? _darkAssetPath : _lightAssetPath;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.42),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(size * 0.42),
          border: Border.all(
            color: borderColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        child: Padding(
          padding: padding,
          child: SizedBox.square(
            dimension: size,
            child: Transform.scale(
              scale: imageScale,
              child: Image.asset(
                assetPathForTheme(theme.brightness),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
