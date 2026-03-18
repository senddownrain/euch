import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF1867C0);

  static ThemeData build(Brightness brightness, String fontFamily) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
    );

    final textTheme = _applyFont(base.textTheme, fontFamily);

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: base.colorScheme.surface,
        foregroundColor: base.colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: base.colorScheme.outlineVariant),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  static TextTheme _applyFont(TextTheme textTheme, String fontFamily) {
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
}
