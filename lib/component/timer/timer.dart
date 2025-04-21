import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'timer_controller.dart';

class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerData = ref.watch(timerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatTimerDisplay(
              timerData.hours, timerData.minutes, timerData.seconds),
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _getStatusText(timerData.state),
          style: TextStyle(
            fontSize: 18,
            color: _getStatusColor(timerData.state),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay),
              iconSize: 32,
              onPressed: timerData.state != TimerState.initial
                  ? () => ref.read(timerProvider.notifier).reset()
                  : null,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: Icon(
                timerData.state == TimerState.running
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              iconSize: 48,
              onPressed: timerData.remainingSeconds > 0
                  ? () {
                      if (timerData.state == TimerState.running) {
                        ref.read(timerProvider.notifier).pause();
                      } else {
                        ref.read(timerProvider.notifier).start();
                      }
                    }
                  : null,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.clear),
              iconSize: 32,
              onPressed: timerData.settings.isEmpty
                  ? null
                  : () => ref.read(timerProvider.notifier).clear(),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Set Timer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton(context, ref,
                        hours: 0, minutes: 5, seconds: 0),
                    _buildTimeButton(context, ref,
                        hours: 0, minutes: 15, seconds: 0),
                    _buildTimeButton(context, ref,
                        hours: 0, minutes: 25, seconds: 0),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton(context, ref,
                        hours: 0, minutes: 30, seconds: 0),
                    _buildTimeButton(context, ref,
                        hours: 1, minutes: 0, seconds: 0),
                    _buildTimeButton(context, ref,
                        hours: 2, minutes: 0, seconds: 0),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showCustomTimerDialog(context, ref),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text('Custom Timer'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeButton(BuildContext context, WidgetRef ref,
      {required int hours, required int minutes, required int seconds}) {
    String label = '';
    if (hours > 0) {
      label = '$hours hr';
      if (minutes > 0) label += ' $minutes min';
    } else {
      label = '$minutes min';
    }

    return ElevatedButton(
      onPressed: () {
        ref.read(timerProvider.notifier).setDuration(
              hours: hours,
              minutes: minutes,
              seconds: seconds,
            );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label),
    );
  }

  void _showCustomTimerDialog(BuildContext context, WidgetRef ref) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Custom Timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Hours: ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Slider(
                      value: hours.toDouble(),
                      min: 0,
                      max: 24,
                      divisions: 24,
                      label: hours.toString(),
                      onChanged: (value) {
                        hours = value.toInt();
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text('$hours', style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Minutes: ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Slider(
                      value: minutes.toDouble(),
                      min: 0,
                      max: 59,
                      divisions: 59,
                      label: minutes.toString(),
                      onChanged: (value) {
                        minutes = value.toInt();
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child:
                        Text('$minutes', style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Seconds: ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Slider(
                      value: seconds.toDouble(),
                      min: 0,
                      max: 59,
                      divisions: 59,
                      label: seconds.toString(),
                      onChanged: (value) {
                        seconds = value.toInt();
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child:
                        Text('$seconds', style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(timerProvider.notifier).setDuration(
                      hours: hours,
                      minutes: minutes,
                      seconds: seconds,
                    );
                Navigator.pop(context);
              },
              child: const Text('Set Timer'),
            ),
          ],
        );
      },
    );
  }

  String _getStatusText(TimerState state) {
    switch (state) {
      case TimerState.initial:
        return 'Ready';
      case TimerState.running:
        return 'Running';
      case TimerState.paused:
        return 'Paused';
      case TimerState.finished:
        return 'Finished';
    }
  }

  Color _getStatusColor(TimerState state) {
    switch (state) {
      case TimerState.initial:
        return Colors.blue;
      case TimerState.running:
        return Colors.green;
      case TimerState.paused:
        return Colors.orange;
      case TimerState.finished:
        return Colors.red;
    }
  }
}
