import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/text_field.dart';
import 'package:to_do_list/notifiers/user_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';
import 'package:to_do_list/pages/home.dart';

part 'login.dart';
part 'register.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userNotifierProvider.notifier).currentUser();
    });
  }

  @override
  void reassemble() { //buat hot reload aja, hapus pas release
    super.reassemble();
    ref.read(userNotifierProvider.notifier).currentUser();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);

    if (state.isLoading) {
      print("Helooo: ${state.isLoading}");
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.error}', style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: () =>
                    ref.read(userNotifierProvider.notifier).currentUser(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final user = state.user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: user == null ? Login() : Dashboard(),
    );
  }
}