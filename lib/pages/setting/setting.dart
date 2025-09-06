import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do_list/component/theme/theme_provider.dart';
import 'package:to_do_list/notifiers/user_notifier.dart';
import 'package:to_do_list/pages/auth/auth.dart';

class Setting extends ConsumerWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.watch(userNotifierProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () async {
              final newTheme = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

              ref.read(themeNotifierProvider.notifier).state = newTheme;

              await const FlutterSecureStorage().write(
                key: 'theme',
                value: newTheme == ThemeMode.dark ? 'dark' : 'light',
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await userNotifier.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Auth()),
                      (route) => false,
                );
              }
            },
            child: const Text("Logout")),
      ),
    );
  }
}
