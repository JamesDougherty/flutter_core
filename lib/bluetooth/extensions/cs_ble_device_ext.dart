import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../core/cs_re_emit_stream_controller.dart';

final Map<DeviceIdentifier, CsReEmitStreamController<bool>> _connectingStreamGlobal = {};
final Map<DeviceIdentifier, CsReEmitStreamController<bool>> _disconnectingStreamGlobal = {};

extension CsBleDeviceExt on BluetoothDevice {
  CsReEmitStreamController<bool> get _connectingStream {
    _connectingStreamGlobal[remoteId] ??= CsReEmitStreamController(initialValue: false);
    return _connectingStreamGlobal[remoteId]!;
  }

  CsReEmitStreamController<bool> get _disconnectingStream {
    _disconnectingStreamGlobal[remoteId] ??= CsReEmitStreamController(initialValue: false);
    return _disconnectingStreamGlobal[remoteId]!;
  }

  Stream<bool> get isConnecting {
    return _connectingStream.stream;
  }

  Stream<bool> get isDisconnecting {
    return _disconnectingStream.stream;
  }

  Future connectAndUpdateStream({int mtu = 512}) async {
    _connectingStream.add(true);
    try {
      await connect(mtu: mtu);
    } on Exception catch (_) {
      await disconnect(queue: false);
    } finally {
      _connectingStream.add(false);
    }
  }

  Future disconnectAndUpdateStream({bool queue = true}) async {
    _disconnectingStream.add(true);
    try {
      await disconnect(queue: queue);
    } finally {
      _disconnectingStream.add(false);
    }
  }
}
