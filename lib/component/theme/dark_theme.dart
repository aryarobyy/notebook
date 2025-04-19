import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme _darkColorScheme = const ColorScheme.dark(
  primary: Color(0xFF9370DB),
  secondary: Color(0xFFFF69B4),
  surface: Color(0xFF1E1E2C),
  background: Color(0xFF121212),

  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onBackground: Colors.white70,
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