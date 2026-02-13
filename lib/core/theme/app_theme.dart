import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark theme with primary background #131313 and night blue secondary colors.
/// Text theme uses Plus Jakarta Sans (Google Sans is not in the public Google Fonts API).
class AppTheme {
  AppTheme._();

  // Primary background
  static const Color backgroundPrimary = Color(0xFF131313);

  // Surface / card
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF0F172A);

  // Night blue palette
  static const Color secondaryDark = Color(0xFF1E3A5F);
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryLighter = Color(0xFF93C5FD);

  // On-surface / text
  static const Color onSurface = Color(0xFFFAFAFA);
  static const Color onSurfaceVariant = Color(0xFFA1A1AA);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);

  static ColorScheme get _colorScheme => ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryLight,
        onPrimaryContainer: backgroundPrimary,
        secondary: secondaryDark,
        onSecondary: onSurface,
        secondaryContainer: primaryLighter.withValues(alpha: 0.2),
        onSecondaryContainer: primaryLighter,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        error: error,
        onError: Colors.white,
        outline: onSurfaceVariant,
        shadow: Colors.black54,
        scrim: Colors.black54,
        inverseSurface: onSurface,
        onInverseSurface: backgroundPrimary,
        surfaceTint: primary,
      );

  static TextTheme get _textTheme {
    // Plus Jakarta Sans (Google Sans is not in the public Google Fonts catalog)
    final base = GoogleFonts.plusJakartaSansTextTheme(
      TextTheme(
        displayLarge: const TextStyle(color: onSurface),
        displayMedium: const TextStyle(color: onSurface),
        displaySmall: const TextStyle(color: onSurface),
        headlineLarge: const TextStyle(color: onSurface),
        headlineMedium: const TextStyle(color: onSurface),
        headlineSmall: const TextStyle(color: onSurface),
        titleLarge: const TextStyle(color: onSurface),
        titleMedium: const TextStyle(color: onSurface),
        titleSmall: const TextStyle(color: onSurface),
        bodyLarge: const TextStyle(color: onSurface),
        bodyMedium: const TextStyle(color: onSurface),
        bodySmall: const TextStyle(color: onSurfaceVariant),
        labelLarge: const TextStyle(color: onSurface),
        labelMedium: const TextStyle(color: onSurfaceVariant),
        labelSmall: const TextStyle(color: onSurfaceVariant),
      ),
    );
    return base;
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: backgroundPrimary,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundPrimary,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: secondaryDark,
        elevation: 0,
        height: 80,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _textTheme.labelMedium?.copyWith(color: primaryLight);
          }
          return _textTheme.labelMedium?.copyWith(color: onSurfaceVariant);
        }),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: _textTheme.titleMedium?.copyWith(color: onSurface),
        subtitleTextStyle: _textTheme.bodySmall?.copyWith(color: onSurfaceVariant),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          textStyle: _textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: secondaryDark,
        labelStyle: _textTheme.labelMedium?.copyWith(color: onSurface),
        secondaryLabelStyle: _textTheme.labelMedium?.copyWith(color: primaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dividerColor: onSurfaceVariant.withValues(alpha: 0.3),
    );
  }
}
