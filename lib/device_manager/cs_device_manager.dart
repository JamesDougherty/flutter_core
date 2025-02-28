import '../core/cs_log.dart';
import '../device_manager/core/cs_device_identifier.dart';
import '../device_manager/core/cs_device_type.dart';
import '../device_manager/devices/valve_evb034/cs_valve_evb034.dart';
import 'core/cs_device.dart' show CsDevice;

class CsDeviceManager {
  static final CsDeviceManager _instance = CsDeviceManager._internal();
  final List<CsDeviceIdentifier> _deviceIdentifiers = [];

  factory CsDeviceManager() {
    return _instance;
  }

  CsDeviceManager._internal();

  ///
  /// Get the list of registered device identifiers.
  ///
  /// **Returns**
  /// - A [List] of [String] objects representing the registered device identifiers.
  ///
  List<String> get deviceIdentifiers => _deviceIdentifiers.map((i) => i.identifier).toList();

  ///
  /// Register a device.
  ///
  /// **Parameters:**
  /// - [CsDeviceIdentifier] deviceId: The device identifier to register.
  ///
  /// **NOTE**
  /// - If the device identifier is already registered, it will not be added again.
  /// - The device identifier *should* be not only unique, but it should be a part of the advertised device name.
  ///
  void registerDevice(CsDeviceIdentifier deviceId) {
    if (!_deviceIdentifiers.contains(deviceId)) {
      CsLog.d(
        '[Device Manager] Registering device identifier [Id: ${deviceId.identifier}] [Type: ${deviceId.deviceType}]',
      );
      _deviceIdentifiers.add(deviceId);
    }
  }

  ///
  /// Get the device for the given device name.
  ///
  /// **Parameters:**
  /// - [String] deviceName: The name of the device to get.
  ///
  /// **Returns**
  /// - A [CsDevice] object representing the device for the given device name. If no device is found, `null` is returned.
  ///
  dynamic getDevice(String deviceName) {
    final CsDeviceIdentifier deviceId = _deviceIdentifiers.firstWhere(
      (d) => deviceName.toLowerCase().startsWith(d.identifier.toLowerCase()),
      orElse: () => CsDeviceIdentifier(identifier: '', deviceType: CsDeviceType.unknown),
    );

    if (deviceId.identifier.isEmpty) {
      CsLog.d('[Device Manager] No device registered for: $deviceName');
      return null;
    }

    return switch (deviceId.deviceType) {
      CsDeviceType.valveEvb034 => CsValveEvb034(),
      _ => null,
    };
  }
}
