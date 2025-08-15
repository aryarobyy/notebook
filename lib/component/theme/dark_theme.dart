import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF9370DB),
    secondary: Color(0xFFFF69B4),
    background: Color(0xFF000000),
    surface: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFFEAEAEA),
    onSurface: Color(0xFFD1D1D1),
    error: Colors.redAccent,
    onError: Colors.white,
    secondaryContainer: Color(0xFF37306B),
  ),
  scaffoldBackgroundColor: const Color(0xFF000000),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF9370DB),
    foregroundColor: Colors.white,
  ),
  textTheme: GoogleFonts.robotoTextTheme(
    ThemeData.dark().textTheme,
  ).apply(
      bodyColor: const Color(0xFFFFFFFF),
      displayColor: const Color(0xFFFFFFFF)
  ),
  fontFamily: GoogleFonts.roboto().fontFamily,
);