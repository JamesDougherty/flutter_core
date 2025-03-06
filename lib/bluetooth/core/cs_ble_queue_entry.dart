import 'package:flutter/foundation.dart';

import '../../device_manager/core/cs_device_base.dart';

@immutable
class CsBleQueueEntry {
  final CsDeviceBase device;
  final List<int> packet;
  final bool expectingDataResponse;

  const CsBleQueueEntry(this.device, this.packet, {this.expectingDataResponse = false});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CsBleQueueEntry &&
        other.device.deviceIdentifier.identifier == device.deviceIdentifier.identifier &&
        other.expectingDataResponse == expectingDataResponse &&
        listEquals(other.packet, packet);
  }

  @override
  int get hashCode => device.hashCode ^ expectingDataResponse.hashCode ^ packet.hashCode;
}
