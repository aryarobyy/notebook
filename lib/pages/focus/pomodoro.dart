import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/pages/focus/pomodoro_controller.dart';

class PomodoroWidget extends ConsumerWidget {
  const PomodoroWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroData = ref.watch(pomodoroProvider);

    final themeColor = _getThemeColor(pomodoroData.mode);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSessionHeader(pomodoroData),
        const SizedBox(height: 40),
        Text(
          formatTime(
              pomodoroData.hours, pomodoroData.minutes, pomodoroData.seconds),
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _getStatusText(pomodoroData.timerState),
          style: TextStyle(
            fontSize: 18,
            color: _getStatusColor(pomodoroData.timerState),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlButton(
              icon: Icons.refresh,
              color: Colors.orange,
              onPressed: pomodoroData.mode != PomodoroMode.idle &&
                      pomodoroData.timerState != TimerState.initial
                  ? () => ref.read(pomodoroProvider.notifier).reset()
                  : null,
            ),
            const SizedBox(width: 24),
            _buildControlButton(
              icon: pomodoroData.timerState == TimerState.running
                  ? Icons.pause
                  : Icons.play_arrow,
              color: themeColor,
              size: 64,
              onPressed: pomodoroData.mode != PomodoroMode.idle &&
                      (pomodoroData.timerState == TimerState.initial ||
                          pomodoroData.timerState == TimerState.paused ||
                          pomodoroData.timerState == TimerState.running)
                  ? () {
                      if (pomodoroData.timerState == TimerState.running) {
                        ref.read(pomodoroProvider.notifier).pause();
                      } else {
                        ref.read(pomodoroProvider.notifier).start();
                      }
                    }
                  : null,
            ),
            const SizedBox(width: 24),
            _buildControlButton(
              icon: Icons.skip_next,
              color: Colors.blue,
              onPressed: pomodoroData.mode != PomodoroMode.idle
                  ? () => ref.read(pomodoroProvider.notifier).skipToNext()
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 50),
        _buildModeSelectors(ref, pomodoroData),
        const SizedBox(height: 30),
        if (pomodoroData.stats.completedSessions > 0)
          _buildStats(pomodoroData.stats),
      ],
    );
  }

  Widget _buildSessionHeader(PomodoroData data) {
    if (data.mode == PomodoroMode.idle) {
      return const Text(
        "Pomodoro Timer",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: _getThemeColor(data.mode).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            data.mode == PomodoroMode.work ? Icons.work : Icons.coffee,
            color: _getThemeColor(data.mode),
          ),
          const SizedBox(width: 8),
          Text(
            PomodoroData.getLabelForMode(data.mode),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _getThemeColor(data.mode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    double size = 40,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(size / 4),
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        elevation: onPressed != null ? 4 : 0,
      ),
      child: Icon(icon, size: size / 2, color: color),
    );
  }

  Widget _buildModeSelectors(WidgetRef ref, PomodoroData data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Sesi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModeButton(
                  ref,
                  label: "Fokus\n25 menit",
                  icon: Icons.work,
                  color: Colors.red,
                  onTap: () =>
                      ref.read(pomodoroProvider.notifier).startWorkSession(),
                ),
                _buildModeButton(
                  ref,
                  label: "Istirahat\n5 menit",
                  icon: Icons.coffee,
                  color: Colors.green,
                  onTap: () => ref
                      .read(pomodoroProvider.notifier)
                      .startShortBreakSession(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
    WidgetRef ref, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(PomodoroStats stats) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Statistik Hari Ini",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  label: "Sesi Selesai:",
                  value: "${stats.completedSessions}",
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                _buildStatItem(
                  label: "Menit Fokus:",
                  value: "${stats.totalWorkMinutes}",
                  icon: Icons.timer,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _getStatusText(TimerState state) {
    switch (state) {
      case TimerState.initial:
        return "Siap";
      case TimerState.running:
        return "Berjalan";
      case TimerState.paused:
        return "Dijeda";
      case TimerState.finished:
        return "Selesai";
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

  Color _getThemeColor(PomodoroMode mode) {
    switch (mode) {
      case PomodoroMode.work:
        return Colors.red;
      case PomodoroMode.shortBreak:
        return Colors.green;
      case PomodoroMode.longBreak:
        return Colors.purple;
      case PomodoroMode.idle:
        return Colors.blue;
    }
  }
}
