
import '../../bluetooth/core/cs_ble_device.dart';
import 'cs_device_type.dart';

abstract class CsDevice {
  CsBleDevice? _bleDevice;
  CsDeviceType get deviceType;
  String get scanFilter;
  String get friendlyName;
  String get alias;

  CsBleDevice? get bleDevice => _bleDevice;
  set bleDevice(CsBleDevice? bleDevice);
}
