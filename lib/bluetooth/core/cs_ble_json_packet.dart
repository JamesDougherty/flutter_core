import 'package:flutter/foundation.dart';

import 'cs_ble_change.dart';
import 'cs_ble_packet.dart';

@immutable
class CsBleJsonPacket {
  final CsBlePacket packet;
  final List<CsBleChange> changes;

  const CsBleJsonPacket({required this.packet, required this.changes});
}
