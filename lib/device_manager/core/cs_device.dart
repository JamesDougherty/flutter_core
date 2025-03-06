import '../../bluetooth/core/cs_ble_device.dart';
import '../../bluetooth/core/cs_ble_gatt_service.dart';
import '../../bluetooth/core/cs_ble_process_data_type.dart';
import 'cs_device_identifier.dart';

abstract class CsDevice {
  ///
  /// The identifier for this device, which is used to uniquely identify the device. The identifier should be part of
  /// the advertisement name for the device.
  ///
  CsDeviceIdentifier get deviceIdentifier;

  ///
  /// The Bluetooth device associated with this device.
  ///
  CsBleDevice? _bleDevice;

  ///
  /// The GATT service associated with this device. This will be used to verify the device is the correct type (from a
  /// Bluetooth perspective) and to get the correct read and write characteristics.
  ///
  CsBleGattService get gattService;

  ///
  /// The type of data that is being processed by the BLE process. The JSON data can have raw data too, like responses,
  /// but this is for defining the main type of data that is being processed. All newer firmware versions should use
  /// JSON data. The raw support is for older firmware versions, such as the EVB-019 (and prior) devices. Note that the
  /// classic Bluetooth devices are no longer being supported in this app, so the raw data is only for BLE devices.
  /// 
  CsBleProcessDataType get processDataType;

  ///
  /// The maximum packet size for BLE packets. This is used to determine how many bytes can be sent in a single packet.
  /// Normally, on modern devices, this should be set to the maximum MTU size that gets negotiated during the device
  /// connection. However, on older devices they may need to be capped to always use a maximum value regardless of what
  /// MTU was negotiated. For instance, the EVB-019 valves may get capped at 20 bytes. This can be set dynamically if
  /// needed too. This, once again, is useful for something like the EVB-019 valves. Those valves will start out with
  /// "jumbo" packets during firmware uploads. If those jumbo packets start failing, then the packet size will be
  /// reduced to 20 bytes.
  ///
  int get maxBlePacketSize;

  ///
  /// The friendly name for this device. This is the name that will be displayed to the user.
  ///
  String get friendlyName;

  ///
  /// The alias for this device. This is a name that can be set by the user to help identify the device.
  ///
  String get alias;

  ///
  /// The Bluetooth device associated with this device.
  ///
  CsBleDevice? get bleDevice => _bleDevice;

  ///
  /// Set the Bluetooth device associated with this device.
  ///
  set bleDevice(CsBleDevice? bleDevice);
}
