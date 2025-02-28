
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum CsBleAdapterState {
  unknown,
  unavailable,
  unauthorized,
  turningOn,
  on,
  turningOff,
  off;

  static CsBleAdapterState fromBluetoothAdapterState(BluetoothAdapterState state) =>
    switch (state) {
      BluetoothAdapterState.unknown => CsBleAdapterState.unknown,
      BluetoothAdapterState.unavailable => CsBleAdapterState.unavailable,
      BluetoothAdapterState.unauthorized => CsBleAdapterState.unauthorized,
      BluetoothAdapterState.turningOn => CsBleAdapterState.turningOn,
      BluetoothAdapterState.on => CsBleAdapterState.on,
      BluetoothAdapterState.turningOff => CsBleAdapterState.turningOff,
      BluetoothAdapterState.off => CsBleAdapterState.off,
    };
}
