import 'package:flutter/foundation.dart';

import '../../device_manager/core/cs_device_base.dart';
import 'cs_ble_process_data_type.dart';

@immutable
class CsBlePacket {
  final CsBleProcessDataType dataType;
  final CsDeviceBase device;
  final List<int> payload;

  const CsBlePacket({required this.dataType, required this.device, required this.payload});
}
