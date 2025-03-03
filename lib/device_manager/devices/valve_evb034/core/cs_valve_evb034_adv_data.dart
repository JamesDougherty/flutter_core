import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '/device_manager/devices/shared/cs_device_salt_sensor_status.dart';
import '/device_manager/devices/shared/cs_device_water_status.dart';
import '/device_manager/devices/valve_evb034/core/cs_valve_evb034_error_state.dart';
import '/device_manager/devices/valve_evb034/core/cs_valve_evb034_series.dart';
import '/device_manager/devices/valve_evb034/core/cs_valve_evb034_type.dart';
import '../../../../bluetooth/extensions/cs_scan_result_ext.dart';
import '../../../../core/cs_log.dart';
import '../../../../extensions/cs_int_ext.dart';
import '../../shared/cs_device_bypass_status.dart';

class CsValveEvb034AdvData {
  List<int> _valveStatusBits = [];
  CsValveEvb034ErrorState _valveErrorState = CsValveEvb034ErrorState.noError;
  int _timeHours = 0;
  int _timeMinutes = 0;
  CsValveEvb034Type _valveType = CsValveEvb034Type.unknown;
  CsValveEvb034Series _series = CsValveEvb034Series.unknown;
  int _firmwareVersionMajor = 0;
  int _firmwareVersionMinor = 0;
  CsDeviceSaltSensorStatus _saltSensorStatus = CsDeviceSaltSensorStatus.unknown;
  CsDeviceWaterStatus _waterStatus = CsDeviceWaterStatus.unknown;
  CsDeviceBypassStatus _bypassStatus = CsDeviceBypassStatus.unknown;

  CsValveEvb034AdvData(ScanResult scanResult) {
    _processManufacturerData(scanResult);
  }

  CsValveEvb034ErrorState get valveErrorState => _valveErrorState;
  int get timeHours => _timeHours;
  int get timeMinutes => _timeMinutes;
  CsValveEvb034Type get valveType => _valveType;
  CsValveEvb034Series get series => _series;
  int get firmwareVersionMajor => _firmwareVersionMajor;
  int get firmwareVersionMinor => _firmwareVersionMinor;
  int get firmwareVersion => (_firmwareVersionMajor * 100) + _firmwareVersionMinor;
  CsDeviceSaltSensorStatus get saltSensorStatus => _saltSensorStatus;
  CsDeviceWaterStatus get waterStatus => _waterStatus;
  CsDeviceBypassStatus get bypassStatus => _bypassStatus;

  void _processManufacturerData(ScanResult scanResult) {
    final manufacturerData = scanResult.advertisementData.manufacturerData;
    const expectedPayloadLength = 8;
    final hasMinLength = manufacturerData.isNotEmpty && manufacturerData.values.first.length >= expectedPayloadLength;

    if (!hasMinLength || !scanResult.isCsiDevice) {
      const String prefix = '[Valve EVB-034] Aborting the processing of the manufacturer data as';
      if (manufacturerData.isEmpty) {
        CsLog.w('$prefix there is no data available');
      } else if (manufacturerData.values.first.length != expectedPayloadLength) {
        CsLog.w(
          '$prefix the data length, ${manufacturerData.values.length} bytes, '
          'is not the expected payload length of $expectedPayloadLength bytes',
        );
      } else {
        CsLog.w('$prefix this is not a CSI device');
      }
      return;
    }

    /*
    ==============================================================================
    Payload Information
    ------------------------------------------------------------------------------
      Firmware C6.01+
      Type: DataTypeManufacturerSpecificData
      Length: 10
      Example Payload: {1850: [0, 0, 8, 38, 1, 3, 6, 11]}
          Map Key - Manufacturer ID (always 0x073A, 1850, for CSI)
          Byte 1 - Valve Status Bits
          Byte 2 - Valve Error State
          Byte 3 - Time (Hours)
          Byte 4 - Time (Minutes)
          Byte 5 - Valve Type
          Byte 6 - Series
          Byte 7 - Firmware Version (Major)
          Byte 8 - Firmware Version (Minor)
    =============================================================================
    */

    _valveStatusBits = manufacturerData.values.first[0].toBits();
    _valveErrorState = CsValveEvb034ErrorState.fromInt(manufacturerData.values.first[1]);
    _timeHours = manufacturerData.values.first[2];
    _timeMinutes = manufacturerData.values.first[3];
    _valveType = CsValveEvb034Type.fromInt(manufacturerData.values.first[4]);
    _series = CsValveEvb034Series.fromInt(manufacturerData.values.first[5]);
    _firmwareVersionMajor = manufacturerData.values.first[6];
    _firmwareVersionMinor = manufacturerData.values.first[7];

    if (_valveStatusBits.isNotEmpty && _valveStatusBits.length >= 3) {
      _saltSensorStatus = CsDeviceSaltSensorStatus.fromInt(_valveStatusBits[0]);
      _waterStatus = CsDeviceWaterStatus.fromInt(_valveStatusBits[1]);
      _bypassStatus = CsDeviceBypassStatus.fromInt(_valveStatusBits[2]);
    }
  }

  @override
  String toString() {
    return '''
      CsValveEvb034AdvData(
        Salt Sensor Status: $saltSensorStatus
        Water Status: $waterStatus
        Bypass Status: $bypassStatus
        Valve Error State: $valveErrorState
        Time (Hours): $timeHours
        Time (Minutes): $timeMinutes
        Valve Type: $valveType
        Series: $series
        Firmware Version: $firmwareVersion
      )
    ''';
  }
}
