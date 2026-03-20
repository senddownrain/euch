import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFF8C6A86);
  static const Color _lightScaffold = Color(0xFFF7F1EB);
  static const Color _lightSurface = Color(0xFFFFFBF7);
  static const Color _darkScaffold = Color(0xFF1C1A1F);
  static const Color _darkSurface = Color(0xFF252228);

  static ThemeData build(Brightness brightness) {
    final theme = switch (brightness) {
      Brightness.light => FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: seedColor,
            primaryContainer: Color(0xFFEADBE5),
            secondary: Color(0xFFB7867A),
            secondaryContainer: Color(0xFFF3DDD5),
            tertiary: Color(0xFF8B869A),
            tertiaryContainer: Color(0xFFE3DEEB),
            appBarColor: _lightSurface,
            error: Color(0xFFB55B5A),
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 8,
          appBarOpacity: 0.92,
          transparentStatusBar: true,
          subThemesData: _subThemes,
          keyColors: const FlexKeyColors(
            keepPrimary: true,
            useSecondary: true,
            useTertiary: true,
          ),
          useMaterial3: true,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          textTheme: _uiTextTheme(Brightness.light),
        ),
      Brightness.dark => FlexThemeData.dark(
          colors: const FlexSchemeColor(
            primary: Color(0xFFD3B5C9),
            primaryContainer: Color(0xFF5A4456),
            secondary: Color(0xFFE0B7A8),
            secondaryContainer: Color(0xFF5F453F),
            tertiary: Color(0xFFC7BED6),
            tertiaryContainer: Color(0xFF474150),
            appBarColor: _darkSurface,
            error: Color(0xFFFFB4AB),
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 12,
          appBarOpacity: 0.9,
          transparentStatusBar: true,
          subThemesData: _subThemes,
          keyColors: const FlexKeyColors(
            keepPrimary: true,
            useSecondary: true,
            useTertiary: true,
          ),
          useMaterial3: true,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          textTheme: _uiTextTheme(Brightness.dark),
        ),
    };

    return theme.copyWith(
      scaffoldBackgroundColor: brightness == Brightness.light ? _lightScaffold : _darkScaffold,
      canvasColor: brightness == Brightness.light ? _lightSurface : _darkSurface,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.84),
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        toolbarHeight: 66,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.24,
        ),
      ),
      cardTheme: theme.cardTheme.copyWith(
        color: theme.colorScheme.surface.withValues(alpha: brightness == Brightness.light ? 0.96 : 0.98),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.34),
          ),
        ),
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        iconColor: theme.colorScheme.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
      chipTheme: theme.chipTheme.copyWith(
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.56),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.24)),
        selectedColor: theme.colorScheme.secondaryContainer.withValues(alpha: 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        labelStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.36),
        thickness: 0.8,
        space: 1,
      ),
      snackBarTheme: theme.snackBarTheme.copyWith(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      bottomSheetTheme: theme.bottomSheetTheme.copyWith(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        modalBarrierColor: Colors.black.withValues(alpha: 0.18),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.34)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.28)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.55)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          foregroundColor: theme.colorScheme.onSurface,
        ),
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        elevation: 0,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      sliderTheme: theme.sliderTheme.copyWith(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
      ),
    );
  }

  static TextStyle readingBodyStyle(
    BuildContext context, {
    required String fontFamily,
    required double multiplier,
    Color? color,
  }) {
    final style = _readerBaseTheme(Theme.of(context).brightness, fontFamily).bodyLarge!;
    return style.copyWith(
      color: color,
      fontSize: (style.fontSize ?? 18) * multiplier,
      height: 1.74,
      letterSpacing: 0.08,
    );
  }

  static TextStyle readingTitleStyle(
    BuildContext context, {
    required String fontFamily,
    required double multiplier,
    double scale = 1,
    FontWeight weight = FontWeight.w600,
    Color? color,
  }) {
    final style = _readerBaseTheme(Theme.of(context).brightness, fontFamily).headlineSmall!;
    return style.copyWith(
      color: color,
      fontSize: (style.fontSize ?? 28) * multiplier * scale,
      height: 1.22,
      letterSpacing: -0.35,
      fontWeight: weight,
    );
  }

  static TextTheme _uiTextTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);
    final bodyColor = brightness == Brightness.light ? const Color(0xFF2B2730) : const Color(0xFFF0E8F0);
    final mutedColor = brightness == Brightness.light ? const Color(0xFF6D6470) : const Color(0xFFC6BBC7);

    return textTheme.copyWith(
      headlineSmall: textTheme.headlineSmall?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.65,
        height: 1.18,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.28,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.14,
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        color: bodyColor,
        height: 1.46,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        color: bodyColor,
        height: 1.42,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        color: mutedColor,
        height: 1.36,
      ),
      labelLarge: textTheme.labelLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      labelMedium: textTheme.labelMedium?.copyWith(
        color: mutedColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.04,
      ),
    );
  }

  static TextTheme _readerBaseTheme(Brightness brightness, String fontFamily) {
    final base = brightness == Brightness.light
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);
    return _applyReadingFont(base.textTheme, fontFamily);
  }

  static TextTheme _applyReadingFont(TextTheme textTheme, String fontFamily) {
    switch (fontFamily) {
      case 'Kurale':
        return GoogleFonts.kuraleTextTheme(textTheme);
      case 'Old Standard TT':
        return GoogleFonts.oldStandardTtTextTheme(textTheme);
      case 'Yeseva One':
        return GoogleFonts.yesevaOneTextTheme(textTheme);
      case 'Comfortaa':
        return GoogleFonts.comfortaaTextTheme(textTheme);
      case 'Pacifico':
        return GoogleFonts.pacificoTextTheme(textTheme);
      default:
        return textTheme;
    }
  }

  static const FlexSubThemesData _subThemes = FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    blendOnLevel: 10,
    blendOnColors: false,
    defaultRadius: 18,
    cardRadius: 24,
    cardElevation: 0,
    cardBorderWidth: 1,
    elevatedButtonRadius: 16,
    filledButtonRadius: 16,
    outlinedButtonRadius: 16,
    textButtonRadius: 14,
    segmentedButtonRadius: 18,
    inputDecoratorRadius: 18,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    fabRadius: 20,
    fabUseShape: true,
    bottomSheetRadius: 30,
    popupMenuRadius: 18,
    chipRadius: 999,
    appBarScrolledUnderElevation: 0,
    appBarCenterTitle: false,
  );
}
