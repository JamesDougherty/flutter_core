import 'dart:async';

import '../extensions/cs_stream_ext.dart';

///
/// A stream controller that re-emits the latest value to new listeners.
///
class CsReEmitStreamController<T> {
  final StreamController<T> _controller = StreamController<T>.broadcast();
  T? _latestValue;

  ///
  /// The latest value that the stream controller has emitted.
  ///
  T? get value => _latestValue;

  ///
  /// Constructor for the [CsReEmitStreamController] class. The [initialValue] parameter is the initial value that the
  /// stream controller will emit to new listeners.
  ///
  /// **Parameters:**
  /// - `initialValue`: The initial value that the stream controller will emit to new listeners.
  ///
  CsReEmitStreamController({T? initialValue}) :
    _latestValue = initialValue;

  ///
  /// Stream getter that returns the stream controller's stream. If the stream controller has an initial value, then
  /// the stream will be created with that value.
  ///
  Stream<T> get stream {
    return _latestValue == null ?
      _controller.stream :
      _controller.stream.initialValueStream(_latestValue as T);
  }

  ///
  /// Adds a new value to the stream controller.
  ///
  void add(T newValue) {
    _latestValue = newValue;
    _controller.add(newValue);
  }

  ///
  /// Closes the stream controller.
  ///
  Future<void> close() {
    return _controller.close();
  }
}
