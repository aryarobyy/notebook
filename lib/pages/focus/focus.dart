import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/pages/focus/pomodoro.dart';

class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Focus"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // TimerWidget()
            PomodoroWidget()
            // Expanded(child: DigitalClockPage())
          ],
        ),
      ),
    );
  }
}
