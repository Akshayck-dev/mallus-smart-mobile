import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CuratorDesign {
  // Light Palette
  static const Color surface = Color(0xFFF8F8F8);
  static const Color surfaceLow = Color(0xFFF2F2F2);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF757575);

  // Dark Palette
  static const Color darkSurface = Color(0xFF0D0D0D); // Deep Charcoal
  static const Color darkSurfaceLow = Color(0xFF161616); // Midnight Ash
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF2F2F2);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Shared
  static const Color primaryOrange = Color(0xFFF37021);
  static const Color accent = Color(0xFFD35400);
  static const Color grey = Color(0xFFEEEEEE);

  // Cinematic Polish Tokens
  static const double cinematicBlur = 25.0;
  
  static Color categoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'FRUITS': return const Color(0xFFE8F5E9); // Botanical Mint
      case 'BAKERY': return const Color(0xFFFFF8E1); // Warm Honey
      case 'GROCERIES': return const Color(0xFFE3F2FD); // Clean Azure
      case 'FASHION': return const Color(0xFFF3E5F5); // Soft Lavender
      default: return surface;
    }
  }

  // Gradients
  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, Color(0xFFFF9A5C)],
  );

  static LinearGradient premiumGradient = primaryGradient;

  static LinearGradient darkPremiumGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
  );

  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? darkSurface : surface,
      cardColor: isDark ? darkCard : card,
      primaryColor: primaryOrange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOrange,
        brightness: isDark ? Brightness.dark : Brightness.light,
        surface: isDark ? darkSurface : surface,
        primary: primaryOrange,
      ),
      textTheme: GoogleFonts.manropeTextTheme().apply(
        bodyColor: isDark ? darkTextPrimary : textDark,
        displayColor: isDark ? darkTextPrimary : textDark,
      ),
    );
  }

  static TextStyle display(double size, {Color? color}) => GoogleFonts.manrope(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.2,
      );

  static TextStyle body(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: size,
        color: color,
        fontWeight: weight ?? FontWeight.w400,
      );

  static TextStyle label(double size, {Color? color}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5,
      );

  static BoxDecoration cardDecoration(bool isDark) => BoxDecoration(
    color: isDark ? darkCard : card,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      width: 1,
    ),
    boxShadow: isDark ? [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ] : [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

