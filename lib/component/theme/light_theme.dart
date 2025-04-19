import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme _lightColorScheme = const ColorScheme.light(
    primary: Color(0xFF9370DB),
    secondary: Colors.orange,
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF2F2F2),

    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black87,
);

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFF9370DB), // Ungu
        surface: Color(0xFFFFFFFF),
        secondary: Color(0xFFFF69B4),
    ),
    scaffoldBackgroundColor: Color(0xFFF2F2F2),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF9370DB),
    ),
    textTheme: GoogleFonts.robotoTextTheme(
        ThemeData.light().textTheme,
    ).apply(
        bodyColor: _lightColorScheme.onBackground,
        displayColor: _lightColorScheme.onBackground,
    ),
    fontFamily: GoogleFonts.roboto().fontFamily,
);
