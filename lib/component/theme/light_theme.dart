import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFF9370DB),
        secondary: Color(0xFFFF69B4),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onBackground: Color(0xFF1F1F1F),
        onSurface: Color(0xFF3A3A3A),
        error: Colors.red,
        onError: Colors.white,
        secondaryContainer: Color(0xFFE9DDFF),
        onSecondaryContainer: Color(0xFF4A2E7E),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF9370DB),
        foregroundColor: Colors.white,
    ),
    textTheme: GoogleFonts.robotoTextTheme(
        ThemeData.light().textTheme,
    ).apply(
        bodyColor: const Color(0xFF000000),
        displayColor: const Color(0xFF000000),
    ),
    fontFamily: GoogleFonts.roboto().fontFamily,
);