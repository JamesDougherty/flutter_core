import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

@immutable
class CsBleDevice {
  final BluetoothDevice device;
  final String localName;
  final DeviceIdentifier address;
  final int rssi;
  final int averageRssi;
  final ScanResult scanResult;

  const CsBleDevice({
    required this.device,
    required this.localName,
    required this.address,
    required this.rssi,
    required this.averageRssi,
    required this.scanResult,
  });

  @override
  bool operator ==(Object other) => other is CsBleDevice && address == other.address;

  @override
  int get hashCode => address.hashCode;

  @override
  String toString() {
    return '''
      CsBleDevice(
        Device: $device
        Local Name: $localName
        Address: $address
        RSSI: $rssi
        Average RSSI: $averageRssi
        Scan Result: $scanResult
      )
    ''';
  }
}
