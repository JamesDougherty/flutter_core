import 'dart:async';

extension CsStreamExt<T> on Stream<T> {
  ///
  /// Creates a new stream that emits the [initialValue] to new listeners.
  ///
  /// **Parameters:**
  /// - `initialValue`: The value to emit to new listeners.
  ///
  /// **Returns:**
  /// - A [Stream] of type [T] that emits the [initialValue] to new listeners.
  ///
  Stream<T> initialValueStream(T initialValue) {
    return transform(_InitialValueStreamTransformer(initialValue));
  }
}

class _InitialValueStreamTransformer<T> extends StreamTransformerBase<T, T> {
  late StreamController<T> controller;
  late StreamSubscription<T> subscription;
  final T initialValue;
  int listenerCount = 0;

  _InitialValueStreamTransformer(this.initialValue);

  @override
  Stream<T> bind(Stream<T> stream) {
    return stream.isBroadcast ? _bind(stream, broadcast: true) : _bind(stream);
  }

  Stream<T> _bind(Stream<T> stream, {bool broadcast = false}) {
    void onData(T data) {
      controller.add(data);
    }

    Future<void> onDone() async {
      await controller.close();
    }

    void onError(Object error) {
      controller.addError(error);
    }

    void onListen() {
      controller.add(initialValue);

      if (listenerCount == 0) {
        subscription = stream.listen(onData, onError: onError, onDone: onDone);
      }

      listenerCount++;
    }

    void onPause() {
      subscription.pause();
    }

    void onResume() {
      subscription.resume();
    }

    Future<void> onCancel() async {
      listenerCount--;

      if (listenerCount <= 0) {
        listenerCount = 0;
        await subscription.cancel();
        await controller.close();
      }
    }

    if (broadcast) {
      controller = StreamController<T>.broadcast(onListen: onListen, onCancel: onCancel);
    } else {
      controller = StreamController<T>(onListen: onListen, onPause: onPause, onResume: onResume, onCancel: onCancel);
    }

    return controller.stream;
  }
}
