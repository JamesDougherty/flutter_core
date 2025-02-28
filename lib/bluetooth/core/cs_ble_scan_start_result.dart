
///
/// Enum to represent the result of a scan start operation.
///
enum CsBleScanStartResult {
  ///
  /// The scan was started successfully.
  /// 
  success,

  ///
  /// An exception occurred while starting the scan. See the logs for more information.
  /// 
  failed,

  ///
  /// The scan is already in progress.
  /// 
  alreadyScanning,

  ///
  /// Bluetooth adapter is current not on.
  /// 
  bluetoothNotOn,

  ///
  /// Bluetooth is not supported on the device.
  /// 
  bluetoothNotSupported,
}
