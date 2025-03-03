import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../core/cs_log.dart';
import 'core/cs_ble_adapter_state.dart';

class CsBle {
  static const int minBlePacketSize = 20;
  static const int maxBlePacketSize = 512;
  static final CsBle _instance = CsBle._internal();
  final StreamController<CsBleAdapterState> _onAdapterStateController = StreamController.broadcast();
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  factory CsBle() {
    return _instance;
  }

  CsBle._internal();

  ///
  /// Initializes the BLE module. This method should be called before using any other methods in the BLE module.
  ///
  Future<void> initialize() async {
    await _adapterStateSubscription?.cancel();

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _onAdapterStateController.add(CsBleAdapterState.fromBluetoothAdapterState(state));
    });
  }

  ///
  /// Disposes the BLE module. This method should be called when the BLE module is no longer needed.
  Future<void> dispose() async {
    if (!_onAdapterStateController.isClosed) {
      await _onAdapterStateController.close();
    }

    await _adapterStateSubscription?.cancel();
  }

  ///
  /// Stream that emits the current adapter state.
  ///
  /// **Returns**
  /// - A [Stream] that emits the current adapter state.
  ///
  Stream<CsBleAdapterState> get onAdapterState => _onAdapterStateController.stream;

  ///
  /// Turns the Bluetooth adapter on.
  ///
  /// **Parameters**
  /// - [timeout]: The maximum time to wait for the adapter to turn on, in seconds. If the adapter does not turn on
  ///              within this time, an error will be thrown.
  ///
  static Future<void> turnAdapterOn({int timeout = 60}) async {
    try {
      await FlutterBluePlus.turnOn(timeout: timeout);
    } on Exception catch (e) {
      CsLog.e('Failed to turn on the Bluetooth adapter: $e');
    }
  }
}
