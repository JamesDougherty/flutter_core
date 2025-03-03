import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../bluetooth/core/cs_ble_connect_result.dart';
import '../../bluetooth/core/cs_ble_connection_state.dart';
import '../../bluetooth/core/cs_ble_device.dart';
import '../../bluetooth/cs_ble.dart';
import '../../bluetooth/cs_ble_scanner.dart';
import '../../bluetooth/extensions/cs_ble_device_ext.dart';
import '../../core/cs_log.dart';
import '../../core/cs_utilities.dart';
import 'cs_device.dart';

abstract class CsDeviceBase implements CsDevice {
  final StreamController<CsBleConnectionState> _onConnectionStateController = StreamController.broadcast();
  final StreamController<List<int>> _onDataReadController = StreamController.broadcast();
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  StreamSubscription<List<int>>? _readSubscription;
  StreamSubscription<int>? _mtuChangeSubscription;
  BluetoothCharacteristic? _readCharacteristic;
  BluetoothCharacteristic? _writeCharacteristic;
  int _negotiatedMtu = CsBle.minBlePacketSize;
  CsBleDevice? _bleDevice;

  @override
  CsBleDevice? get bleDevice => _bleDevice;

  @override
  set bleDevice(CsBleDevice? bleDevice) {
    _bleDevice = bleDevice;
    onBleDeviceUpdated(bleDevice);
  }

  Future<void> initialize() async {
    _connectionStateSubscription = _bleDevice?.device.connectionState.listen(_onConnectionState);
  }

  Future<void> dispose() async {
    if (!_onConnectionStateController.isClosed) {
      await _onConnectionStateController.close();
    }

    if (!_onDataReadController.isClosed) {
      await _onDataReadController.close();
    }

    await _connectionStateSubscription?.cancel();
    await _mtuChangeSubscription?.cancel();
    await _readSubscription?.cancel();
  }

  bool get isConnected => _bleDevice?.device.isConnected ?? false;

  int get negotiatedMtu => _negotiatedMtu;

  Stream<CsBleConnectionState> get onConnectionState => _onConnectionStateController.stream;

  Stream<List<int>> get onDataRead => _onDataReadController.stream;

  void onBleDeviceUpdated(CsBleDevice? bleDevice);

  Future<CsBleConnectResult> connect() async {
    if (_bleDevice == null) {
      CsLog.e('[Device Base] Cannot connect; BLE device is null');
      return CsBleConnectResult.invalidDevice;
    }

    if (isConnected) {
      CsLog.e('[Device Base] Device is already connected');
      return CsBleConnectResult.alreadyConnected;
    }

    await CsBleScanner().stopScan();

    try {
      await _bleDevice?.device.connectAndUpdateStream();
    } /*on Exception*/ catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error connecting:', e));
    }

    return CsBleConnectResult.success;
  }

  Future<void> disconnect() async {
    if (_bleDevice == null) {
      CsLog.e('[Device Base] Cannot disconnect; BLE device is null');
      return Future.value();
    }

    if (!isConnected) {
      CsLog.e('[Device Base] Device is already disconnected');
      return Future.value();
    }

    try {
      await _bleDevice?.device.disconnectAndUpdateStream();
    } on Exception catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error disconnecting:', e));
    }
  }

  Future<void> _onConnectionState(BluetoothConnectionState state) async {
    CsLog.d('[Device Base] Connection state changed to $state for device $_bleDevice');

    try {
      if (state == BluetoothConnectionState.connected) {
        await _onConnected();
        _onConnectionStateController.sink.add(CsBleConnectionState.connected);
      } else if (state == BluetoothConnectionState.disconnected) {
        await _onDisconnected();
        _onConnectionStateController.sink.add(CsBleConnectionState.disconnected);
      }
    } /*on Exception*/ catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error in _onConnectionState:', e));
    }
  }

  Future<void> _onConnected() async {
    if (_bleDevice == null) {
      CsLog.e('[Device Base] Cannot connect; BLE device is null');
    }

    try {
      if (_mtuChangeSubscription != null) {
        await _mtuChangeSubscription?.cancel();
      }

      _mtuChangeSubscription = _bleDevice?.device.mtu.listen((mtu) {
        CsLog.d('[Device Base] MTU changed to $mtu');
        _negotiatedMtu = mtu;
      });
    } /*on Exception*/ catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error setting up MTU change subscription:', e));
    }

    try {
      final bool discoverResult = await _discoveryCharacteristics();

      if (!discoverResult) {
        CsLog.e('[Device Base] Error discovering characteristics for device $_bleDevice');
        await disconnect();
        return;
      }

      //
    } /*on Exception*/ catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error in _onConnected:', e));
    }
  }

  Future<void> _onDisconnected() async {
    try {
      await _readCharacteristic?.setNotifyValue(false);
    } /*on Exception*/ catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Set Notify Error:', e));
    }

    try {
      _readCharacteristic = null;
      _writeCharacteristic = null;
    } /*on Exception*/ catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error in _onDisconnected:', e));
    }
  }

  Future<bool> _discoveryCharacteristics() async {
    try {
      final List<BluetoothService>? services = await _bleDevice?.device.discoverServices();

      if (services == null) {
        CsLog.e('[Device Base] No services discovered for device $_bleDevice');
        return Future.value(false);
      }

      for (final service in services) {
        if (service.uuid == gattService.serviceUuid) {
          for (final characteristic in service.characteristics) {
            if (characteristic.uuid == gattService.readCharacteristicUuid) {
              _readCharacteristic = characteristic;
            } else if (characteristic.uuid == gattService.writeCharacteristicUuid) {
              _writeCharacteristic = characteristic;
            }
          }
        }
      }

      if (_readCharacteristic == null) {
        CsLog.e(
          '[Device Base] Could not find the read characteristic ${gattService.readCharacteristicUuid} '
          '(service ${gattService.serviceUuid}) for device $_bleDevice',
        );
        return Future.value(false);
      }

      if (_writeCharacteristic == null) {
        CsLog.e(
          '[Device Base] Could not find the write characteristic ${gattService.writeCharacteristicUuid} '
          '(service ${gattService.serviceUuid}) for device $_bleDevice',
        );
        return Future.value(false);
      }

      if (_readCharacteristic != null) {
        try {
          await _readCharacteristic!.setNotifyValue(true);
        } on Exception catch (e) {
          CsLog.e(CsUtilities.exceptionToString('[Device Base] Set Notify Error:', e));
          return Future.value(false);
        }

        try {
          if (_readSubscription != null) {
            await _readSubscription?.cancel();
          }

          _readSubscription = _readCharacteristic!.lastValueStream.listen(_onRead);
        } on Exception catch (e) {
          CsLog.e(CsUtilities.exceptionToString('[Device Base] Error setting up read subscription:', e));
          return Future.value(false);
        }
      }

      CsLog.d(
        '[Device Base] Discovered characteristics for device $_bleDevice: '
        '[Read: $_readCharacteristic] [Write: $_writeCharacteristic]',
      );

      return Future.value(true);
    } on Exception catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error discovering services:', e));
    }

    return Future.value(false);
  }

  void _onRead(List<int> buffer) {
    CsLog.d('[<<< Read] $buffer');
    _onDataReadController.sink.add(buffer);
  }

  Future<bool> write(List<int> buffer) async {
    if (!isConnected) {
      CsLog.e('[Device Base] Not connected, cannot write data to device $_bleDevice');
      return Future.value(false);
    }

    if (_writeCharacteristic == null) {
      CsLog.e('[Device Base] Write characteristic is null, cannot write data to device $_bleDevice');
      return Future.value(false);
    }

    try {
      CsLog.d('[>>> Write] $buffer');
      await _writeCharacteristic!.write(buffer, withoutResponse: true);
      return Future.value(true);
    } on Exception catch (e) {
      CsLog.e(CsUtilities.exceptionToString('[Device Base] Error writing buffer:', e));
      return Future.value(false);
    }
  }
}
