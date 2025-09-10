import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    const storage = FlutterSecureStorage();
    final savedTheme = await storage.read(key: 'theme');

    if (savedTheme == 'dark') {
      state = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      state = ThemeMode.light;
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'theme', value: themeMode == ThemeMode.dark ? 'dark' : 'light');

    state = themeMode;
  }
}
