import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static const Color shellBackground = Color(0xFF07111F);
  static const Color panelColor = Color(0xFF0F1B31);
  static const Color neonCyan = Color(0xFF4CF7FF);
  static const Color neonGreen = Color(0xFF6BFF9D);
  static const Color neonPink = Color(0xFFFF6FDB);
  static const Color neonOrange = Color(0xFFFFB15A);
  static const Color textPrimary = Color(0xFFF5FBFF);
  static const Color textMuted = Color(0xFF96AFCB);

  static const LinearGradient shellGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF03070D), Color(0xFF0A1424), Color(0xFF091A2B)],
  );

  static ThemeData dark() {
    final TextTheme baseTextTheme = GoogleFonts.orbitronTextTheme(
      ThemeData.dark(useMaterial3: true).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: shellBackground,
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonPink,
        surface: panelColor,
        onSurface: textPrimary,
        onPrimary: shellBackground,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF06101D),
        indicatorColor: Color(0x3338D7E5),
        labelTextStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: textPrimary,
          height: 1.4,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: textMuted),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: panelColor.withValues(alpha: 0.84),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
