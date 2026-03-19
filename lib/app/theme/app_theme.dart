import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFF2C6EB8);
  static const Color _lightScaffold = Color(0xFFF6F1EA);
  static const Color _lightSurface = Color(0xFFFFFCF7);
  static const Color _darkScaffold = Color(0xFF16181C);
  static const Color _darkSurface = Color(0xFF1D2025);

  static ThemeData build(Brightness brightness) {
    final theme = switch (brightness) {
      Brightness.light => FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: seedColor,
            primaryContainer: Color(0xFFD8E7F7),
            secondary: Color(0xFF8B6F47),
            secondaryContainer: Color(0xFFF0E4CF),
            tertiary: Color(0xFF667A96),
            tertiaryContainer: Color(0xFFD8E2F0),
            appBarColor: _lightSurface,
            error: Color(0xFFBA4D4B),
          ),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 6,
          appBarOpacity: 0.88,
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
            primary: Color(0xFF82B0E3),
            primaryContainer: Color(0xFF1E3552),
            secondary: Color(0xFFD1B88F),
            secondaryContainer: Color(0xFF4A3C27),
            tertiary: Color(0xFFAEBFDA),
            tertiaryContainer: Color(0xFF324154),
            appBarColor: _darkSurface,
            error: Color(0xFFFFB4AB),
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 10,
          appBarOpacity: 0.8,
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
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.82),
        foregroundColor: theme.colorScheme.onSurface,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 24,
        toolbarHeight: 76,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: theme.cardTheme.copyWith(
        color: theme.colorScheme.surface.withValues(alpha: brightness == Brightness.light ? 0.92 : 0.96),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.42),
          ),
        ),
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        iconColor: theme.colorScheme.onSurfaceVariant,
      ),
      chipTheme: theme.chipTheme.copyWith(
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
        selectedColor: theme.colorScheme.secondaryContainer.withValues(alpha: 0.9),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        labelStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
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
        modalBarrierColor: Colors.black.withValues(alpha: 0.22),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.55)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          foregroundColor: theme.colorScheme.onSurface,
        ),
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
      height: 1.72,
      letterSpacing: 0.12,
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
      height: 1.25,
      letterSpacing: -0.3,
      fontWeight: weight,
    );
  }

  static TextTheme _uiTextTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);
    final bodyColor = brightness == Brightness.light ? const Color(0xFF21262D) : const Color(0xFFE6EAF0);
    final mutedColor = brightness == Brightness.light ? const Color(0xFF5E6773) : const Color(0xFFA9B1BC);

    return textTheme.copyWith(
      headlineSmall: textTheme.headlineSmall?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        height: 1.2,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        color: bodyColor,
        height: 1.45,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        color: bodyColor,
        height: 1.42,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        color: mutedColor,
        height: 1.4,
      ),
      labelLarge: textTheme.labelLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      labelMedium: textTheme.labelMedium?.copyWith(
        color: mutedColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
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
    blendOnLevel: 8,
    blendOnColors: false,
    defaultRadius: 16,
    cardRadius: 20,
    cardElevation: 0,
    cardBorderWidth: 1,
    elevatedButtonRadius: 14,
    filledButtonRadius: 14,
    outlinedButtonRadius: 14,
    textButtonRadius: 14,
    segmentedButtonRadius: 16,
    inputDecoratorRadius: 18,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    fabRadius: 18,
    fabUseShape: true,
    bottomSheetRadius: 28,
    popupMenuRadius: 18,
    chipRadius: 999,
    appBarScrolledUnderElevation: 0,
    appBarCenterTitle: false,
  );
}
