import 'package:flutter/foundation.dart';

import 'cs_ble_packet.dart';
import 'cs_ble_packet_rx_change.dart';

@immutable
class CsBleJsonPacket {
  final CsBlePacket packet;
  final List<CsBlePacketRxChange> changes;

  const CsBleJsonPacket({required this.packet, required this.changes});
}
