import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../core/cs_log.dart';
import '../device_manager/core/cs_device_base.dart';
import '../device_manager/cs_device_manager.dart';
import 'core/cs_ble_device.dart';
import 'core/cs_ble_rssi_average.dart';
import 'core/cs_ble_scan_start_result.dart';

///
/// Class to handle scanning for BLE devices.
///
class CsBleScanner {
  static final CsBleScanner _instance = CsBleScanner._internal();
  final StreamController<bool> _onScanStatusController = StreamController.broadcast();
  final StreamController<CsDeviceBase> _onDeviceScannedController = StreamController.broadcast();
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<bool>? _isScanningSubscription;
  AndroidScanMode _androidScanMode = AndroidScanMode.lowLatency;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unavailable;
  final Map<DeviceIdentifier, CsBleRssiAverage> _rssiAverages = {};
  final List<ScanResult> _scanResults = [];
  bool _lastScanStatus = false;
  bool _uniqueDevicesOnly = false;
  List<String> _filters = [];
  int _timeoutMs = 7500;

  factory CsBleScanner() {
    return _instance;
  }

  CsBleScanner._internal();

  ///
  /// Initialize the BLE scanner. This method should be called before using any other methods in the BLE scanner.
  ///
  Future<void> initialize() async {
    await _setupSubscriptions();
  }

  ///
  /// Dispose of the BLE scanner. This method should be called when the BLE scanner is no longer needed.
  ///
  Future<void> dispose() async {
    await stopScan();

    if (!_onScanStatusController.isClosed) {
      await _onScanStatusController.close();
    }

    if (!_onDeviceScannedController.isClosed) {
      await _onDeviceScannedController.close();
    }

    await _isScanningSubscription?.cancel();
    await _scanResultsSubscription?.cancel();
    await _adapterStateSubscription?.cancel();
  }

  ///
  /// Get the current scan status.
  ///
  bool get isScanning => FlutterBluePlus.isScanningNow;

  ///
  /// Stream that emits a boolean value indicating if a scan is in progress or not.
  /// True if a scan is in progress, false otherwise.
  ///
  /// **Returns**
  /// - A [Stream] that emits a boolean value indicating if a scan is in progress or not.
  ///
  Stream<bool> get onScanStatus => _onScanStatusController.stream;

  ///
  /// Stream that emits [CsBleDevice] objects when a device is scanned.
  ///
  /// **Returns**
  /// - A [Stream] that emits [CsBleDevice] objects when a device is scanned.
  ///
  Stream<CsDeviceBase> onDeviceScanned() => _onDeviceScannedController.stream;

  ///
  /// Start scanning for BLE devices. The scan will run for [timeoutMs] milliseconds using the specified
  /// [androidScanMode] mode. If [uniqueDevicesOnly] is set to true, then only unique devices will be included in the
  /// scan results. A device is considered unique if it has not been seen before during the scan.
  ///
  /// Returns a [CsBleScanStartResult] to indicate the result of the operation.
  ///
  /// **NOTE**
  /// This method expects Bluetooth to be supported and that the Bluetooth adapter is turned on.
  ///
  /// Start scanning for BLE devices.
  ///
  /// The scan will run for [timeoutMs] milliseconds using the specified [androidScanMode] mode.
  /// If [uniqueDevicesOnly] is set to true, then only unique devices will be included in the scan results.
  ///
  /// **Parameters**
  /// - `timeoutMs`: The duration of the scan in milliseconds. Default is 7500 ms.
  /// - `androidScanMode`: The scan mode to use on Android devices. Default is [AndroidScanMode.lowLatency].
  /// - `uniqueDevicesOnly`: Whether to include only unique devices in the scan results. Default is false.
  ///
  /// **Returns**
  /// - A [CsBleScanStartResult] to indicate the result of the operation.
  ///
  Future<CsBleScanStartResult> startScan({
    int timeoutMs = 7500,
    AndroidScanMode androidScanMode = AndroidScanMode.lowLatency,
    bool uniqueDevicesOnly = false,
  }) async {
    assert(timeoutMs >= 2500, 'Timeout must be at least 2500 milliseconds');

    if (FlutterBluePlus.isScanningNow) {
      CsLog.w('[BLE Scanner] Scan already in progress');
      return CsBleScanStartResult.alreadyScanning;
    } else if (!await FlutterBluePlus.isSupported) {
      CsLog.e('[BLE Scanner] Bluetooth is not supported on this device');
      return CsBleScanStartResult.bluetoothNotSupported;
    } else if (_adapterState != BluetoothAdapterState.on) {
      CsLog.w('[BLE Scanner] Bluetooth adapter is not on');
      return CsBleScanStartResult.bluetoothNotOn;
    }

    _filters = CsDeviceManager().deviceIdentifiers;

    CsLog.d('[BLE Scanner] Scan starting [Timeout: $timeoutMs ms] [Filters: $_filters]');

    try {
      await FlutterBluePlus.startScan(timeout: Duration(milliseconds: timeoutMs));
    } on Exception catch (e) {
      CsLog.e('[BLE Scanner] Error starting scan: $e');
      return CsBleScanStartResult.failed;
    }

    _timeoutMs = timeoutMs;
    _androidScanMode = androidScanMode;
    _uniqueDevicesOnly = uniqueDevicesOnly;

    return CsBleScanStartResult.success;
  }

  ///
  /// Stop scanning for BLE devices.
  ///
  Future<void> stopScan() async {
    if (!FlutterBluePlus.isScanningNow) {
      CsLog.w('[BLE Scanner] No scan in progress');
      return;
    }

    CsLog.i('[BLE Scanner] Stopping scan');

    try {
      await FlutterBluePlus.stopScan();
    } on Exception catch (e) {
      CsLog.e('[BLE Scanner] Error stopping scan: $e');
    }
  }

  ///
  /// Restart the scan with the same parameters as the previous scan. If no previous scan has been started, then this
  /// method will use the default values for the scan. The default values are a timeout of 7500 milliseconds and a scan
  /// mode of [AndroidScanMode.lowLatency].
  ///
  Future<void> restart() async {
    await stopScan();
    await startScan(uniqueDevicesOnly: _uniqueDevicesOnly, timeoutMs: _timeoutMs, androidScanMode: _androidScanMode);
  }

  ///
  /// Determine if a device should be filtered out of the scan results based on the filters provided.
  ///
  /// **Parameters**
  /// - `scanResult`: The [ScanResult] object to check.
  ///
  /// **Returns**
  /// - True if the device should be filtered out, false otherwise.
  ///
  bool _deviceFiltered(ScanResult scanResult) =>
      _filters.isNotEmpty &&
      !_filters.any((filter) => scanResult.advertisementData.advName.toLowerCase().startsWith(filter.toLowerCase()));

  ///
  /// Determine if a device is unique based on the [_uniqueDevicesOnly] flag and the scan results.
  ///
  /// **Parameters**
  /// - `scanResult`: The [ScanResult] object to check.
  ///
  bool _deviceUnique(ScanResult scanResult) => !_uniqueDevicesOnly || !_scanResults.contains(scanResult);

  ///
  /// Handle a device being discovered during a scan. This method will update the average RSSI value for the device and
  /// emit a [CsBleDevice] object.
  ///
  /// **Parameters**
  /// - `scanResult`: The [ScanResult] object representing the discovered device.
  ///
  void _onDeviceDiscovered(ScanResult scanResult) {
    final DeviceIdentifier address = scanResult.device.remoteId;

    final int rssiPercent = (100.0 * (127.0 + scanResult.rssi) / (127.0 + 20.0)).toInt();
    int rssiAverage = rssiPercent;

    if (!_rssiAverages.containsKey(address)) {
      _rssiAverages[address] = CsBleRssiAverage();
    } else {
      _rssiAverages[address]?.update(scanResult.rssi);
      rssiAverage = _rssiAverages[address]?.average ?? 0;
    }

    final CsDeviceBase? device = CsDeviceManager().getDevice(scanResult.advertisementData.advName);

    if (device == null) {
      return;
    }

    device.bleDevice = CsBleDevice(
      device: scanResult.device,
      localName: scanResult.advertisementData.advName,
      address: address,
      rssi: scanResult.rssi,
      averageRssi: rssiAverage,
      scanResult: scanResult,
    );

    _onDeviceScannedController.sink.add(device);
  }

  ///
  /// Setup the subscriptions for the BLE scanner.
  ///
  Future<void> _setupSubscriptions() async {
    await _adapterStateSubscription?.cancel();
    await _isScanningSubscription?.cancel();
    await _scanResultsSubscription?.cancel();

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen(_onIsScanning);
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(_onScanResults);
  }

  ///
  /// Handle the scan status changing.
  ///
  /// **Parameters**
  /// - `isScanning`: True if a scan is in progress, false otherwise.
  ///
  void _onIsScanning(bool isScanning) {
    if (_lastScanStatus == isScanning) {
      return;
    }

    _scanResults.clear();
    _lastScanStatus = isScanning;
    _onScanStatusController.sink.add(isScanning);
    CsLog.i('[BLE Scanner] Scan ${isScanning ? 'started' : 'completed'}');
  }

  ///
  /// Handle the scan results.
  ///
  /// **Parameters**
  /// - `scanResults`: A list of [ScanResult] objects representing the devices discovered during the scan.
  ///
  void _onScanResults(List<ScanResult> scanResults) {
    for (final ScanResult scanResult in scanResults) {
      if (scanResult.advertisementData.advName.isEmpty ||
          scanResult.device.platformName.isEmpty ||
          !scanResult.advertisementData.connectable ||
          !_deviceUnique(scanResult) ||
          _deviceFiltered(scanResult)) {
        continue;
      }

      _scanResults.add(scanResult);
      _onDeviceDiscovered(scanResult);
    }
  }
}
