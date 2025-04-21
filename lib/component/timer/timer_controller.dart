part of 'timer.dart';

enum TimerState { //mulai, jalan, pause, selesai
  initial,
  running,
  paused,
  finished
}

class TimerSettings {
  final int hours;
  final int minutes;
  final int seconds;

  const TimerSettings({
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
  });

  int get totalSeconds => (hours * 3600) + (minutes * 60) + seconds;
  bool get isEmpty => hours == 0 && minutes == 0 && seconds == 0;

  TimerSettings copyWith({ //modelnya
    int? hours,
    int? minutes,
    int? seconds,
  }) {
    return TimerSettings(
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
    );
  }
}

class TimerData {
  final TimerState state;
  final TimerSettings settings;
  final int remainingSeconds;

  const TimerData({
    required this.state,
    required this.settings,
    required this.remainingSeconds,
  });

  int get hours => remainingSeconds ~/ 3600;
  int get minutes => (remainingSeconds % 3600) ~/ 60;
  int get seconds => remainingSeconds % 60;

  factory TimerData.initial() {
    const settings = TimerSettings(hours: 0, minutes: 0, seconds: 0);
    return const TimerData(
      state: TimerState.initial,
      settings: settings,
      remainingSeconds: 0,
    );
  }

  TimerData copyWith({
    TimerState? state,
    TimerSettings? settings,
    int? remainingSeconds,
  }) {
    return TimerData(
      state: state ?? this.state,
      settings: settings ?? this.settings,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerData> {
  Timer? _timer;

  TimerNotifier() : super(TimerData.initial());

  void setDuration({int hours = 0, int minutes = 0, int seconds = 0}) {
    final settings = TimerSettings(hours: hours, minutes: minutes, seconds: seconds);
    state = TimerData(
      state: TimerState.initial,
      settings: settings,
      remainingSeconds: settings.totalSeconds,
    );
  }

  void start() {
    if (state.state == TimerState.running) return;
    if (state.remainingSeconds <= 0) return;

    state = state.copyWith(state: TimerState.running);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 1) {
        _timer?.cancel();
        state = state.copyWith(
          state: TimerState.finished,
          remainingSeconds: 0,
        );
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });
  }

  void pause() {
    if (state.state != TimerState.running) return;

    _timer?.cancel();
    state = state.copyWith(state: TimerState.paused);
  }

  void reset() {
    _timer?.cancel();
    state = TimerData(
      state: TimerState.initial,
      settings: state.settings,
      remainingSeconds: state.settings.totalSeconds,
    );
  }

  void clear() {
    _timer?.cancel();
    state = TimerData.initial();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerData>((ref) {
  return TimerNotifier();
});

String formatTwoDigits(int n) {
  return n < 10 ? "0$n" : "$n";
}

String formatTimerDisplay(int hours, int minutes, int seconds) {
  return "${formatTwoDigits(hours)}:${formatTwoDigits(minutes)}:${formatTwoDigits(seconds)}";
}