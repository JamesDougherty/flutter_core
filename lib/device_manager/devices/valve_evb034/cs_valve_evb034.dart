import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '/core/cs_shared_preferences.dart';
import '/device_manager/core/cs_device_base.dart';
import '/device_manager/core/cs_device_type.dart';
import '/device_manager/devices/valve_evb034/core/cs_valve_evb034_adv_data.dart';
import '../../../bluetooth/core/cs_ble_device.dart';
import '../../../bluetooth/core/cs_ble_gatt_service.dart';
import '../../../bluetooth/core/cs_ble_process_data_type.dart';
import '../../../bluetooth/cs_ble.dart';
import '../../../branding/cs_branding_core_strings.dart';
import '../../../core/cs_log.dart';
import '../../core/cs_device_identifier.dart';

class CsValveEvb034 extends CsDeviceBase {
  StreamSubscription<List<int>>? _readSubscription;
  CsValveEvb034AdvData? _advertisementData;

  @override
  Future<void> initialize() {
    _readSubscription = onDataRead.listen((data) {
      CsLog.d('[Valve EVB-034] Data received: $data');
    });
    return super.initialize();
  }

  @override
  Future<void> dispose() async {
    await _readSubscription?.cancel();
    return super.dispose();
  }

  @override
  CsDeviceIdentifier get deviceIdentifier => CsDeviceIdentifier(
    identifier: CsBrandingCoreStringsValveEvb034.valveEvb034Identifier,
    deviceType: CsDeviceType.valveEvb034,
  );

  @override
  int get maxBlePacketSize => CsBle.maxBlePacketSize;

  @override
  CsBleGattService get gattService => CsBleGattService(
    serviceUuid: Guid('a725458c-bee1-4d2e-9555-edf5a8082303'),
    readCharacteristicUuid: Guid('a725458c-bee2-4d2e-9555-edf5a8082303'),
    writeCharacteristicUuid: Guid('a725458c-bee3-4d2e-9555-edf5a8082303'),
  );

  @override
  CsBleProcessDataType get processDataType => CsBleProcessDataType.json;

  @override
  String get alias => CsSharedPreferences().getDeviceAlias(bleDevice?.address) ?? '';

  @override
  String get friendlyName => _friendlyName(bleDevice?.localName.toLowerCase() ?? '');

  @override
  void onBleDeviceUpdated(CsBleDevice? bleDevice) {
    if (bleDevice != null) {
      _advertisementData = CsValveEvb034AdvData(bleDevice.scanResult);
      CsLog.d('[Valve EVB-034] Advertisement data updated: $_advertisementData');
    }
  }

  CsValveEvb034AdvData? get advData => _advertisementData;

  @override
  String toString() {
    return '''
      CsValveEvb034(
        Device: $bleDevice
        Device Type: ${deviceIdentifier.deviceType}
        Scan Filter: ${deviceIdentifier.identifier}
        Friendly Name: $friendlyName
        Alias: $alias
      )
    ''';
  }

  static String _friendlyName(String deviceName) => switch (deviceName.toLowerCase()) {
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
