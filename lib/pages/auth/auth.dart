import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/text_field.dart';
import 'package:to_do_list/notifiers/user_notifier.dart';
import 'package:to_do_list/pages/home.dart';

part 'login.dart';
part 'register.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(() => _initializeAuth());
  }

  Future<void> _initializeAuth() async {
    await ref.read(userNotifierProvider.notifier).currentUser();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isLoading) {
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
                onPressed: () => _initializeAuth(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final user = state.user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: user == null ? Register() : Home(),
    );
  }
}