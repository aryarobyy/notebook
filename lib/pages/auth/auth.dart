import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/text_field.dart';
import 'package:to_do_list/component/widget/loading.dart';
import 'package:to_do_list/component/widget/popup.dart';
import 'package:to_do_list/notifiers/user_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).currentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UserState>(userNotifierProvider, (previousState, newState) {
      if (newState.isLoading) {
        print('State sedang loading...');
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (newState.error != null) {
          print('Ada error, navigate ke Login');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
          );
        } else if (newState.user != null) {
          print('User ditemukan, navigate ke Dashboard');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Dashboard()),
          );
        } else {
          print('User null tanpa error, navigate ke Login');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
          );
        }
      });
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
