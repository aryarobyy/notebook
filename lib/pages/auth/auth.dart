import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/text_field.dart';
import 'package:to_do_list/component/widget/popup.dart';
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
    ref.read(userNotifierProvider.notifier).currentUser();
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.error != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else if (state.user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      }
    });

    final user = state.user;
    if(state.isLoading){
      return CircularProgressIndicator();
    }

    print("Usweeaew $user");

    if (user != null) {
      return Dashboard();
    }

    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}