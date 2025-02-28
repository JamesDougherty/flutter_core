
import '../../bluetooth/core/cs_ble_device.dart';
import 'cs_device.dart';

abstract class CsDeviceBase implements CsDevice {
  CsBleDevice? _bleDevice;

  @override
  CsBleDevice? get bleDevice => _bleDevice;

  @override
  set bleDevice(CsBleDevice? bleDevice) {
    _bleDevice = bleDevice;
    onBleDeviceUpdated(bleDevice);
  }

  void onBleDeviceUpdated(CsBleDevice? bleDevice);
}
