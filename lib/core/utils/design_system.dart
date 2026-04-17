import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CuratorDesign {
  // Spacing Tokens (Modular Grid)
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;

  // Border Radius Tokens
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusExtraLarge = 32.0;

  // Centralized Radius
  static const double radius = 20.0;

  // Standard Colors (Mallu Smart Identity)
  static const Color primary = Color(0xFF2E7D32); // Deep Kerala Green
  static const Color primaryLight = Color(0xFF66BB6A); // Soft Green
  static const Color secondary = Color(0xFFFFA000); // Earthy Amber
  static const Color background = Color(0xFFFBFBFB); 
  static const Color textPrimaryValue = Color(0xFF1B1B1B); 
  static const Color textSecondaryValue = Color(0xFF757575); 

  // Theme Palette
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLow = Color(0xFFF1F8E9); // Light green tint surface
  static const Color card = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1B1B1B);
  static const Color textLight = Color(0xFF616161);

  // Dark Palette (Premium Forest Dark)
  static const Color darkSurface = Color(0xFF0C1409);
  static const Color darkSurfaceLow = Color(0xFF1B2616);
  static const Color darkCard = Color(0xFF253321);
  static const Color darkTextPrimary = Color(0xFFE8F5E9);
  static const Color darkTextSecondary = Color(0xFFA5D6A7);

  // Theme-aware accessors
  static Color surfaceColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkSurface : surface;
  static Color surfaceLowColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkSurfaceLow : surfaceLow;
  static Color textPrimary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : textDark;
  static Color textSecondary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : textLight;
  static Color cardColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkCard : card;

  // Dividers
  static Color softDivider(BuildContext context) => (Theme.of(context).brightness == Brightness.dark 
      ? Colors.white : Colors.black).withValues(alpha: 0.05);

  // Gradients (Premium Mallu Style)
  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF1B5E20)], // Forest Gradient
  );

  static LinearGradient cinematicGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight], // Vibrant Green Gradient
  );

  static LinearGradient glassGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        (isDark ? Colors.white : Colors.white).withValues(alpha: 0.15),
        (isDark ? Colors.white : Colors.white).withValues(alpha: 0.05),
      ],
    );
  }

  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? darkSurface : background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: isDark ? Brightness.dark : Brightness.light,
        surface: isDark ? darkSurface : background,
        primary: primary,
        secondary: secondary,
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: isDark ? darkTextPrimary : textDark,
        displayColor: isDark ? darkTextPrimary : textDark,
      ),
      dividerTheme: DividerThemeData(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
      ),
      cardTheme: CardThemeData(
        color: isDark ? darkCard : card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
        elevation: 0,
      ),
    );
  }

  // Typography Helpers
  static TextStyle title({Color? color}) => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle heading({Color? color}) => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  static TextStyle subtitle({Color? color}) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: color ?? textSecondaryValue,
        height: 1.5,
      );

  static TextStyle price({Color? color}) => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: color ?? primary,
        height: 1.2,
      );

  // New Design Primitives
  static TextStyle body(double size, {Color? color, FontWeight? weight}) => GoogleFonts.inter(
        fontSize: size,
        color: color,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.6,
      );

  static TextStyle label(double size, {Color? color, FontWeight? weight}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w600,
        color: color,
        letterSpacing: 0.2,
        height: 1.4,
      );

  // Decorations
  static BoxDecoration cardDecoration([bool isDark = false]) => BoxDecoration(
    color: isDark ? darkCard : card,
    borderRadius: BorderRadius.circular(radiusLarge),
    border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
  );

  static BoxDecoration premiumButtonDecoration({required List<Color> colors}) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    ),
    borderRadius: BorderRadius.circular(radiusMedium),
    boxShadow: [
      BoxShadow(
        color: colors.first.withValues(alpha: 0.25),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration glassDecoration({required BuildContext context, double opacity = 0.1}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: (isDark ? Colors.black : Colors.white).withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radiusMedium),
      border: Border.all(
        color: (isDark ? Colors.white : Colors.white).withValues(alpha: 0.1),
        width: 1.5,
      ),
    );
  }
  // ── Alias tokens (kept for backward widget compatibility) ──────────────
  static const Color primaryIndigo = primary;
  static const Color primaryOrange = secondary;
  static const Color secondaryIndigo = primaryLight;

  // Spacing aliases
  static const double s8 = s;    // 8.0
  static const double s16 = m;   // 16.0

  // display() — alias for title with custom size
  static TextStyle display(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w800,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );
}
