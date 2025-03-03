import 'package:flutter/widgets.dart';

///
/// A class that provides a method to compute a CRC-16 checksum using the CRC-16-CCITT algorithm.
///
@immutable
class CsCrc16 {
  ///
  /// Method to compute the CRC-16 checksum.
  ///
  /// **Parameters**
  /// - [buffer]: The buffer to compute the CRC-16 checksum for.
  /// - [seed]: The initial value of the CRC-16 checksum.
  ///
  /// **Returns**
  /// - The computed CRC-16 checksum.
  ///
  static int compute(List<int> buffer, [int seed = 0xFFFF]) {
    var crc = seed;

    for (final byte in buffer) {
      crc = (crc >> 8 | (crc << 8)) & 0xFFFF;
      crc = crc ^ (byte & 0xFF);
      crc = crc ^ (crc & 0xFF >> 4);
      crc = crc ^ (crc << 12 & 0xFFFF);
      crc = crc ^ (crc & 0xFF << 5 & 0xFFFF);
    }

    return crc & 0xFFFF;
  }
}
