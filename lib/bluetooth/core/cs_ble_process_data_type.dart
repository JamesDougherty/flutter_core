
///
/// The type of data that is being processed by the BLE process. The JSON data can have raw data too, like responses,
/// but this is for defining the main type of data that is being processed. All newer firmware versions should use
/// JSON data. The raw support is for older firmware versions, such as the EVB-019 (and prior) devices. Note that the
/// classic Bluetooth devices are no longer being supported in this app, so the raw data is only for BLE devices.
///
enum CsBleProcessDataType {
  ///
  /// Raw data
  ///
  raw,

  ///
  /// JSON data
  ///
  json,
}
