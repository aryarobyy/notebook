import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme _darkColorScheme = const ColorScheme.dark(
  primary: Color(0xFFB39DDB),
  secondary: Color(0xFFFFA726),
  surface: Color(0xFF1E1E2C),
  background: Color(0xFF121212),

  onPrimary: Color(0xFF121212),
  onSecondary: Color(0xFF121212),
  onSurface: Color(0xFFEAEAEA),
  onBackground: Color(0xFFCCCCCC),
);


final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9370DB),
      surface: Color(0xFF1E1E2C), // Background
      secondary: Color(0xFFFF69B4),
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9370DB),
    ),
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: _darkColorScheme.onBackground,
      displayColor: _darkColorScheme.onBackground,
    ),
    fontFamily: GoogleFonts.roboto().fontFamily,
);