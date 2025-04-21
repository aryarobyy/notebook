import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PomodoroMode { work, shortBreak, longBreak, idle }

enum TimerState { initial, running, paused, finished }

class PomodoroStats {
  final int completedSessions;
  final int totalWorkMinutes;

  const PomodoroStats({
    this.completedSessions = 0,
    this.totalWorkMinutes = 0,
  });

  PomodoroStats copyWith({
    int? completedSessions,
    int? totalWorkMinutes,
  }) {
    return PomodoroStats(
      completedSessions: completedSessions ?? this.completedSessions,
      totalWorkMinutes: totalWorkMinutes ?? this.totalWorkMinutes,
    );
  }
}

class PomodoroData {
  final TimerState timerState;
  final PomodoroMode mode;
  final int remainingSeconds;
  final PomodoroStats stats;

  const PomodoroData({
    required this.timerState,
    required this.mode,
    required this.remainingSeconds,
    required this.stats,
  });

  factory PomodoroData.initial() {
    return const PomodoroData(
      timerState: TimerState.initial,
      mode: PomodoroMode.idle,
      remainingSeconds: 0,
      stats: PomodoroStats(),
    );
  }

  int get hours => remainingSeconds ~/ 3600;
  int get minutes => (remainingSeconds % 3600) ~/ 60;
  int get seconds => remainingSeconds % 60;

  PomodoroData copyWith({
    TimerState? timerState,
    PomodoroMode? mode,
    int? remainingSeconds,
    PomodoroStats? stats,
  }) {
    return PomodoroData(
      timerState: timerState ?? this.timerState,
      mode: mode ?? this.mode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      stats: stats ?? this.stats,
    );
  }

  static int getDurationForMode(PomodoroMode mode) {
    switch (mode) {
      case PomodoroMode.work:
        return 25 * 60;
      case PomodoroMode.shortBreak:
        return 5 * 60;
      case PomodoroMode.longBreak:
        return 15 * 60;
      case PomodoroMode.idle:
        return 0;
    }
  }

  static String getLabelForMode(PomodoroMode mode) {
    switch (mode) {
      case PomodoroMode.work:
        return "Fokus";
      case PomodoroMode.shortBreak:
        return "Istirahat Pendek";
      case PomodoroMode.longBreak:
        return "Istirahat Panjang";
      case PomodoroMode.idle:
        return "Siap Mulai";
    }
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroData> {
  Timer? _timer;

  PomodoroNotifier() : super(PomodoroData.initial());

  void startWorkSession() {
    _cancelTimer();

    final workDuration = PomodoroData.getDurationForMode(PomodoroMode.work);
    state = PomodoroData(
      timerState: TimerState.initial,
      mode: PomodoroMode.work,
      remainingSeconds: workDuration,
      stats: state.stats,
    );
  }

  void startShortBreakSession() {
    _cancelTimer();

    final breakDuration =
        PomodoroData.getDurationForMode(PomodoroMode.shortBreak);
    state = PomodoroData(
      timerState: TimerState.initial,
      mode: PomodoroMode.shortBreak,
      remainingSeconds: breakDuration,
      stats: state.stats,
    );
  }

  void startLongBreakSession() {
    _cancelTimer();

    final breakDuration =
        PomodoroData.getDurationForMode(PomodoroMode.longBreak);
    state = PomodoroData(
      timerState: TimerState.initial,
      mode: PomodoroMode.longBreak,
      remainingSeconds: breakDuration,
      stats: state.stats,
    );
  }

  void start() {
    if (state.timerState == TimerState.running) return;
    if (state.remainingSeconds <= 0) return;
    if (state.mode == PomodoroMode.idle) return;

    state = state.copyWith(timerState: TimerState.running);

    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 1) {
        _handleSessionComplete();
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });
  }

  void _handleSessionComplete() {
    _cancelTimer();

    if (state.mode == PomodoroMode.work) {
      final updatedStats = state.stats.copyWith(
        completedSessions: state.stats.completedSessions + 1,
        totalWorkMinutes: state.stats.totalWorkMinutes + 25,
      );

      state = state.copyWith(
        timerState: TimerState.finished,
        remainingSeconds: 0,
        stats: updatedStats,
      );

      if (updatedStats.completedSessions % 4 == 0) {
        startLongBreakSession();
        start();
        return;
      }

      startShortBreakSession();
      start();
    } else if (state.mode == PomodoroMode.shortBreak) {
      state = state.copyWith(
        timerState: TimerState.finished,
        remainingSeconds: 0,
      );

      startWorkSession();
      start();
    }
  }

  void pause() {
    if (state.timerState != TimerState.running) return;

    _cancelTimer();
    state = state.copyWith(timerState: TimerState.paused);
  }

  void reset() {
    _cancelTimer();

    final duration = PomodoroData.getDurationForMode(state.mode);
    state = state.copyWith(
      timerState: TimerState.initial,
      remainingSeconds: duration,
    );
  }

  void resetAll() {
    _cancelTimer();
    state = PomodoroData.initial();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void skipToNext() {
    if (state.mode == PomodoroMode.work) {
      startShortBreakSession();
    } else if (state.mode == PomodoroMode.shortBreak) {
      startWorkSession();
    } else {
      startWorkSession();
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroData>((ref) {
  return PomodoroNotifier();
});

String formatTwoDigits(int n) {
  return n < 10 ? "0$n" : "$n";
}

String formatTime(int hours, int minutes, int seconds) {
  if (hours > 0) {
    return "${formatTwoDigits(hours)}:${formatTwoDigits(minutes)}:${formatTwoDigits(seconds)}";
  }
  return "${formatTwoDigits(minutes)}:${formatTwoDigits(seconds)}";
}
