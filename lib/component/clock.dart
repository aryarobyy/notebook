import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeNotifier extends StateNotifier<DateTime> {
  late final Timer _timer;

  TimeNotifier() : super(DateTime.now()) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final timeProvider = StateNotifierProvider<TimeNotifier, DateTime>((ref) {
  return TimeNotifier();
});

class DigitalClockPage extends ConsumerWidget {
  const DigitalClockPage({super.key});

  String _formatTwoDigits(int n) => n < 10 ? "0$n" : "$n"; //2 digit

  String _formatTime(DateTime time) {
    return "${_formatTwoDigits(time.hour)}:${_formatTwoDigits(time.minute)}:${_formatTwoDigits(time.second)}";
  }

  String _formatDate(DateTime time) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];

    int dayIndex = time.weekday - 1;
    String day = days[dayIndex];

    return "$day, ${months[time.month - 1]} ${time.day}, ${time.year}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(timeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Clock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(currentTime),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _formatDate(currentTime),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
