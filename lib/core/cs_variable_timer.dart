import 'dart:async';

///
/// A class that provides a timer that allows the duration to be changed after it has been created.
///
class CsVariableTimer implements Timer {
  void Function(CsVariableTimer) callback;
  Duration duration;
  Timer? _timer;
  int _tick = 0;

  ///
  /// Creates a new instance of the [CsVariableTimer] class.
  ///
  /// **Parameters**
  /// - [initialDuration]: The initial duration of the timer.
  /// - [callback]: The callback that will be called when the timer ticks.
  ///
  CsVariableTimer(Duration initialDuration, this.callback) : duration = initialDuration {
    _timer = Timer(initialDuration, _onTimer);
  }

  ///
  /// Gets whether or not the timer is active.
  ///
  @override
  bool get isActive => _timer != null;

  ///
  /// Method used to get the current tick count of the timer.
  ///
  @override
  int get tick => _tick;

  ///
  /// Method used to cancel the timer.
  ///
  @override
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTimer() {
    final stopwatch = Stopwatch()..start();
    _tick++;

    callback(this);

    if (isActive) {
      _timer = Timer(duration - stopwatch.elapsed, _onTimer);
    }
  }
}
