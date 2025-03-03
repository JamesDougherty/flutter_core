import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import '../core/cs_crc16.dart';
import '../core/cs_log.dart';
import '../core/cs_utilities.dart';
import '../core/cs_variable_timer.dart';
import '../device_manager/core/cs_device_base.dart';
import 'core/cs_ble_change.dart';
import 'core/cs_ble_json_packet.dart';
import 'core/cs_ble_packet.dart';
import 'core/cs_ble_process_data_type.dart';
import 'core/cs_ble_processor_ack_nak.dart';
import 'core/cs_ble_queue_entry.dart';

class CsBleProcessor {
  static final CsBleProcessor _instance = CsBleProcessor._internal();
  static final StreamController<void> _onBleProcessorReconnectRequest = StreamController.broadcast();
  static final StreamController<CsBleProcessorAckNakType> _onBleProcessorAckNakReceived = StreamController.broadcast();
  static final StreamController<CsBlePacket> _onBleProcessorRawPacketReceived = StreamController.broadcast();
  static final StreamController<CsBleJsonPacket> _onBleProcessorJsonPacketReceived = StreamController.broadcast();
  static final StreamController<String> _onBleProcessorError = StreamController.broadcast();
  static final ListQueue<CsBleQueueEntry> _packetQueue = ListQueue();
  static final ListQueue<CsBleQueueEntry> _queue = ListQueue();
  static CsBleProcessDataType _dataType = CsBleProcessDataType.json;
  static final Map<String, List<int>> _receiveBuffers = {};
  static CsVariableTimer? _processorTimer;
  static bool _idPacketAcknowledged = false;
  static bool _processorRunning = false;
  static bool _processingEntry = false;
  static CsBleQueueEntry? _lastEntry;
  static Timer? _timeoutTimer;
  static int _packetRetry = 0;

  factory CsBleProcessor() {
    return _instance;
  }

  CsBleProcessor._internal();

  Future<void> dispose() async {
    stop();

    if (!_onBleProcessorReconnectRequest.isClosed) {
      await _onBleProcessorReconnectRequest.close();
    }

    if (!_onBleProcessorAckNakReceived.isClosed) {
      await _onBleProcessorAckNakReceived.close();
    }

    if (!_onBleProcessorRawPacketReceived.isClosed) {
      await _onBleProcessorRawPacketReceived.close();
    }

    if (!_onBleProcessorJsonPacketReceived.isClosed) {
      await _onBleProcessorJsonPacketReceived.close();
    }

    if (!_onBleProcessorError.isClosed) {
      await _onBleProcessorError.close();
    }
  }

  static Stream<void> get onBleProcessorReconnectRequest => _onBleProcessorReconnectRequest.stream;
  static Stream<CsBleProcessorAckNakType> get onBleProcessorAckNakReceived => _onBleProcessorAckNakReceived.stream;
  static Stream<CsBlePacket> get onBleProcessorRawPacketReceived => _onBleProcessorRawPacketReceived.stream;
  static Stream<CsBleJsonPacket> get onBleProcessorJsonPacketReceived => _onBleProcessorJsonPacketReceived.stream;
  static Stream<String> get onBleProcessorError => _onBleProcessorError.stream;

  static Future<void> start(CsBleProcessDataType dataType) async {
    stop();
    _resetCurrentEntry();
    _dataType = dataType;
    _processorRunning = true;
    _processorTimer = CsVariableTimer(
      const Duration(milliseconds: _CsBleProcessorConstants.processorIdPacketDelayMs),
      _onProcessorTick,
    );
  }

  static void stop() {
    _queue.clear();
    _packetQueue.clear();
    _processorRunning = false;
    _processorTimer?.cancel();
  }

  static void queuePacket(CsBleQueueEntry entry) {
    if (_processorRunning) {
      _queue.add(entry);
    }
  }

  static Future<void> processResponse(CsDeviceBase device, List<int> buffer) async {
    if (!_processingEntry) {
      return;
    }

    if (buffer.length < _CsBleProcessorConstants.headerSizeBytes) {
      _finalizeFailedResponse('Invalid Packet Data');
      return;
    }

    if (_dataType == CsBleProcessDataType.raw) {
      _processRawPacket(device, buffer);
    } else {
      if (!await _processStatusPacket(device, buffer)) {
        await _processDataPacket(device, buffer);
      }
    }
  }

  static Future<void> _onProcessorTick(CsVariableTimer timer) async {
    if (!_processingEntry && _queue.isNotEmpty) {
      _processingEntry = true;
      _chunkPacket(_queue.first);
    }

    if (_lastEntry == null && _packetQueue.isNotEmpty) {
      if (_packetQueue.first.device.isConnected) {
        _lastEntry = _packetQueue.removeFirst();
        await _retryCurrentPacket();
      } else {
        _packetQueue.removeFirst();
      }
    }

    if (_idPacketAcknowledged) {
      timer.duration = const Duration(milliseconds: _CsBleProcessorConstants.processorDelayMs);
    }
  }

  static void _processRawPacket(CsDeviceBase device, List<int> buffer) {
    _onBleProcessorRawPacketReceived.sink.add(
      CsBlePacket(dataType: CsBleProcessDataType.raw, device: device, payload: buffer),
    );
  }

  static Future<bool> _processStatusPacket(CsDeviceBase device, List<int> buffer) async {
    if (!device.isConnected || buffer.length < _CsBleProcessorConstants.headerSizeBytes) {
      return Future.value(false);
    }

    final header = buffer[0];

    // If this was a raw data packet, then the response acts as the ACK.
    if ((_lastEntry?.expectingDataResponse ?? false) && _packetQueue.isEmpty) {
      _cancelTimeout();
      _queue.removeFirst();
      _resetCurrentEntry();
      //return Future.value(true);
    }

    // Keep-Alive Packet
    if ((header & _CsBleProcessorConstants.headerKeepAlive) > 0) {
      _cancelTimeout();
      await _writeKeepAlivePacket(
        device,
        (header & _CsBleProcessorConstants.headerKeepAliveType > 0)
            ? _CsBleProcessorKeepAliveType.marco
            : _CsBleProcessorKeepAliveType.polo,
      );
      _lastEntry = null;
      _packetRetry = 0;
      return true;
    }

    // ACK / NAK Packet
    if ((header & _CsBleProcessorConstants.headerAckNak) > 0) {
      _cancelTimeout();

      if (!_idPacketAcknowledged) {
        _idPacketAcknowledged = true;
        return Future.value(true);
      }

      if ((header & _CsBleProcessorConstants.headerAckNakType) > 0) {
        _onBleProcessorAckNakReceived.sink.add(CsBleProcessorAckNakType.ack);
        if (_packetQueue.isEmpty) {
          _queue.removeFirst();
          _resetCurrentEntry();
        } else {
          _lastEntry = null;
          _packetRetry = 0;
        }
      } else {
        _onBleProcessorAckNakReceived.sink.add(CsBleProcessorAckNakType.nak);
        await _retryCurrentPacket();
      }
      return Future.value(true);
    }

    // Timeout Packet
    if ((header & _CsBleProcessorConstants.headerTimeout) > 0) {
      await _writeTimeoutPacket(
        device,
        (header & _CsBleProcessorConstants.headerTimeoutType > 0)
            ? _CsBleProcessorTimeoutType.query
            : _CsBleProcessorTimeoutType.ack,
      );
      if (++_packetRetry <= _CsBleProcessorConstants.packetTimeoutRetries) {
        _resetCurrentEntry();
      } else {
        _queue.removeFirst();
      }
      return Future.value(true);
    }

    return Future.value(false);
  }

  static Future<void> _processDataPacket(CsDeviceBase device, List<int> buffer) async {
    if (!device.isConnected || buffer.length < _CsBleProcessorConstants.crcSizeBytes || device.bleDevice == null) {
      return;
    }

    final address = device.bleDevice?.address.toString() ?? '';
    final dataSize = buffer.length - _CsBleProcessorConstants.crcSizeBytes;
    final header = buffer[0];
    final newPacket = buffer.sublist(0, dataSize);
    final expectedCrc = (buffer[buffer.length - 1] << 8) | buffer[buffer.length - 2];
    final actualCrc = CsCrc16.compute(newPacket);

    if (expectedCrc != actualCrc) {
      final expected = expectedCrc.toRadixString(16);
      final actual = actualCrc.toRadixString(16);
      CsLog.d('[BLE Processor] Invalid CRC - [Expected: $expected] [Actual: $actual]');
      await _writeAckNakPacket(device, CsBleProcessorAckNakType.nak);
      return;
    }

    if ((header & _CsBleProcessorConstants.headerFirstPacket) > 0) {
      _receiveBuffers[address] = [];
    }

    if (_receiveBuffers[address] == null) {
      return;
    }

    final packetData = newPacket.sublist(_CsBleProcessorConstants.headerSizeBytes, newPacket.length);

    _receiveBuffers[address]!.addAll(packetData);

    if ((header & _CsBleProcessorConstants.headerLastPacket) > 0) {
      _cancelTimeout();
      await _writeAckNakPacket(device, CsBleProcessorAckNakType.ack);

      try {
        if (_receiveBuffers[address] == null) {
          _resetCurrentEntry();
          return;
        }

        final jsonString = String.fromCharCodes(_receiveBuffers[address]!).trim();
        final jsonData = json.decode(jsonString) as Map<String, dynamic>;
        final changes = List<CsBleChange>.empty(growable: true);

        for (final entry in jsonData.entries) {
          changes.add(CsBleChange(key: entry.key, value: jsonData[entry.key]));
        }

        final packet = CsBlePacket(
          dataType: CsBleProcessDataType.json,
          device: device,
          payload: _receiveBuffers[address]!,
        );

        _onBleProcessorJsonPacketReceived.sink.add(CsBleJsonPacket(packet: packet, changes: changes));
      } catch (ex) {
        CsLog.e('[BLE Processor] $ex');
        _finalizeFailedResponse(ex.toString());
      }

      _resetCurrentEntry();
    } else {
      _restartTimeout();
      await _writeAckNakPacket(device, CsBleProcessorAckNakType.ack);
    }
  }

  static void _chunkPacket(CsBleQueueEntry entry) {
    _packetQueue.clear();

    if (!entry.device.isConnected || entry.packet.isEmpty) {
      return;
    }

    final negotiatedMtu = min(entry.device.negotiatedMtu, entry.device.maxBlePacketSize);
    final packetMtu = negotiatedMtu - _CsBleProcessorConstants.headerAndCrcSizeBytes;
    final headerCrcBytes = entry.packet.length / packetMtu.toDouble() * _CsBleProcessorConstants.headerAndCrcSizeBytes;
    final totalPackets = (entry.packet.length + headerCrcBytes).ceil() ~/ negotiatedMtu;

    for (var i = 0; i < totalPackets; i++) {
      final offset = i * packetMtu;
      final chunkLength = min(packetMtu, entry.packet.length - offset);
      final chunk = entry.packet.sublist(offset, offset + chunkLength);
      _addChunkToQueue(entry, i, totalPackets - 1, chunk, expectingDataResponse: entry.expectingDataResponse);
    }
  }

  static void _addChunkToQueue(
    CsBleQueueEntry entry,
    int chunkId,
    int totalChunks,
    List<int> buffer, {
    required bool expectingDataResponse,
  }) {
    final header =
        (chunkId == 0 ? _CsBleProcessorConstants.headerFirstPacket : _CsBleProcessorConstants.headerNop) |
        (chunkId >= totalChunks ? _CsBleProcessorConstants.headerLastPacket : _CsBleProcessorConstants.headerNop);

    final headerBytes = [(header & 0xFF)];
    final newPayload = List<int>.from(headerBytes)..addAll(buffer);
    final crcBuffer = CsUtilities.shortToByteArray(CsCrc16.compute(newPayload));
    final chunk = List<int>.from(newPayload)..addAll(crcBuffer);

    _packetQueue.add(CsBleQueueEntry(entry.device, chunk, expectingDataResponse: expectingDataResponse));
  }

  static Future<void> _retryCurrentPacket() async {
    if (!_processorRunning) {
      _queue.clear();
      _packetQueue.clear();
      return;
    }

    if (_lastEntry == null) {
      _resetCurrentEntry();
      return;
    }

    if (++_packetRetry <= _CsBleProcessorConstants.packetRetries) {
      if (!_lastEntry!.device.isConnected) {
        await _lastEntry!.device.connect();
      }
      if (!await _lastEntry!.device.write(_lastEntry!.packet)) {
        _finalizeFailedResponse('Failed to write packet');
      } else {
        _restartTimeout();
      }
    } else {
      _queue.removeFirst();
      _finalizeFailedResponse('Packet Retries Exceeded');
    }
  }

  static void _restartTimeout() {
    _cancelTimeout();
    if (_lastEntry!.device.isConnected) {
      _timeoutTimer = Timer(const Duration(milliseconds: _CsBleProcessorConstants.processorTimeoutMs), () {
        _finalizeFailedResponse('Timeout');
      });
    } else {
      _finalizeFailedResponse('Device not connected');
    }
  }

  static void _cancelTimeout() {
    _timeoutTimer?.cancel();
  }

  static Future<bool> _writeKeepAlivePacket(CsDeviceBase device, _CsBleProcessorKeepAliveType type) async {
    return _writeStatusPacket(
      device,
      _CsBleProcessorConstants.headerSinglePacket |
          _CsBleProcessorConstants.headerKeepAlive |
          (type == _CsBleProcessorKeepAliveType.polo
              ? _CsBleProcessorConstants.headerKeepAliveType
              : _CsBleProcessorConstants.headerNop),
    );
  }

  static Future<bool> _writeAckNakPacket(CsDeviceBase device, CsBleProcessorAckNakType type) async {
    return _writeStatusPacket(
      device,
      _CsBleProcessorConstants.headerSinglePacket |
          _CsBleProcessorConstants.headerAckNak |
          (type == CsBleProcessorAckNakType.ack
              ? _CsBleProcessorConstants.headerAckNakType
              : _CsBleProcessorConstants.headerNop),
    );
  }

  static Future<bool> _writeTimeoutPacket(CsDeviceBase device, _CsBleProcessorTimeoutType type) async {
    return _writeStatusPacket(
      device,
      _CsBleProcessorConstants.headerSinglePacket |
          _CsBleProcessorConstants.headerTimeout |
          (type == _CsBleProcessorTimeoutType.ack
              ? _CsBleProcessorConstants.headerTimeoutType
              : _CsBleProcessorConstants.headerNop),
    );
  }

  static Future<bool> _writeStatusPacket(CsDeviceBase device, int header) async {
    if (!device.isConnected) {
      _finalizeFailedResponse('Device not connected');
      return Future.value(false);
    }
    return device.write([(header & 0xFF)]);
  }

  static void _finalizeFailedResponse(String response) {
    _onBleProcessorError.sink.add(response);
    _queue.removeFirst();
    _resetCurrentEntry();
  }

  static void _resetCurrentEntry() {
    _packetRetry = 0;
    _lastEntry = null;
    _processingEntry = false;
  }
}

enum _CsBleProcessorKeepAliveType { marco, polo }

enum _CsBleProcessorTimeoutType { query, ack }

class _CsBleProcessorConstants {
  static const processorIdPacketDelayMs = 400;
  static const processorDelayMs = 10;
  static const processorTimeoutMs = 3000;
  static const packetRetries = 2;
  static const packetTimeoutRetries = 2;
  static const headerSizeBytes = 1;
  static const crcSizeBytes = 2;
  static const headerAndCrcSizeBytes = headerSizeBytes + crcSizeBytes;

  static const headerFirstPacket = 0x80;
  static const headerLastPacket = 0x40;
  static const headerKeepAlive = 0x20;
  static const headerKeepAliveType = 0x10;
  static const headerAckNak = 0x8;
  static const headerAckNakType = 0x4;
  static const headerTimeout = 0x2;
  static const headerTimeoutType = 0x1;
  static const headerNop = 0x0;
  static const headerSinglePacket = headerFirstPacket | headerLastPacket;
}
