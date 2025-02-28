import '/core/cs_shared_preferences.dart';
import '/device_manager/core/cs_device_base.dart';
import '/device_manager/core/cs_device_type.dart';
import '/device_manager/devices/valve_evb034/core/cs_valve_evb034_adv_data.dart';
import '../../../bluetooth/core/cs_ble_device.dart';
import '../../../branding/cs_branding_core_strings.dart';
import '../../../core/cs_log.dart';

class CsValveEvb034 extends CsDeviceBase {
  CsValveEvb034AdvData? _advertisementData;

  @override
  CsDeviceType get deviceType => CsDeviceType.valveEvb034;

  @override
  String get scanFilter => CsBrandingCoreStringsValveEvb034.valveEvb034Identifier;

  @override
  String get alias => CsSharedPreferences().getDeviceAlias(bleDevice?.address) ?? '';

  @override
  String get friendlyName => _friendlyName(bleDevice?.localName.toLowerCase() ?? '');

  @override
  void onBleDeviceUpdated(CsBleDevice? bleDevice) {
    if (bleDevice != null) {
      _advertisementData = CsValveEvb034AdvData(bleDevice.scanResult);
      CsLog.d('CsValveEvb034 advertisement data updated: $_advertisementData');
    }
  }

  CsValveEvb034AdvData? get advData => _advertisementData;

  @override
  String toString() {
    return '''
      CsValveEvb034(
        Device: $bleDevice
        Device Type: $deviceType
        Scan Filter: $scanFilter
        Friendly Name: $friendlyName
        Alias: $alias
      )
    ''';
  }

  static String _friendlyName(String deviceName) =>
    switch (deviceName.toLowerCase()) {
      'c2_01' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC201,
      'c2_02' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC202,
      'c2_03' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC203,
      'c2_04' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC204,
      'c2_05' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC205,
      'c2_06' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC206,
      'c2_07' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC207,
      'c2_08' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC208,
      'c2_09' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC209,
      'c2_0a' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC20A,
      'c2_0b' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC20B,
      'c2_0c' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC20C,
      'c2_0d' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC20D,
      'c2_0e' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC20E,
      'c2_0f' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC20F,
      'c2_10' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC210,
      'c2_11' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC211,
      'c2_12' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC212,
      'c2_13' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC213,
      'c2_14' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC214,
      'c2_15' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC215,
      'c2_16' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC216,
      'c2_17' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC217,
      'c2_18' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC218,
      'c2_19' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC219,
      'c2_1a' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC21A,
      'c2_1b' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC21B,
      'c2_fe' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC2FE,
      'c2_ff' => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameC2FF,
      _ => CsBrandingCoreStringsValveEvb034.valveEvb034FriendlyNameUnknown,
    };
}
