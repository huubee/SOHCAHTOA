import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trig_sct/src/config/theme/app_colors.dart';

class AppTheme {
  static final TextTheme _appTextTheme = TextTheme(
    displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.openSans(fontSize: 14),
  );

  static final ThemeData lightTheme = _buildTheme(AppColors.primary1, Brightness.light);
  static final ThemeData darkTheme = _buildTheme(AppColors.primary1, Brightness.dark);

  static final ThemeData lightTheme2 = _buildTheme(AppColors.primary2, Brightness.light);
  static final ThemeData darkTheme2 = _buildTheme(AppColors.primary2, Brightness.dark);

  static final ThemeData lightTheme3 = _buildTheme(AppColors.primary3, Brightness.light);
  static final ThemeData darkTheme3 = _buildTheme(AppColors.primary3, Brightness.dark);

  static ThemeData _buildTheme(Color seedColor, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
