import 'package:flutter/foundation.dart';

import 'cs_ble_packet_value_type.dart';

@immutable
class CsBlePacketTxChange {
  final String key;
  final CsBlePacketValueType valueType;
  final dynamic value;
  final int minValue;
  final int maxValue;

  const CsBlePacketTxChange({
    required this.key,
    required this.valueType,
    required this.value,
    required this.minValue,
    required this.maxValue,
  });

  ///
  /// Function to convert a list of [CsBlePacketTxChange] objects to a JSON string.
  ///
  /// **Parameters**
  /// - [List<CsBleChange>] changes: The list of changes to convert to a JSON string.
  ///
  /// **Returns**
  /// - A [String] object representing the JSON string of the changes.
  ///
  static String changesToJson(List<CsBlePacketTxChange> changes) {
    if (changes.isEmpty) {
      return '';
    }

    var json = '{';
    var index = 1;

    for (final change in changes) {
      final valueQuote = change.value is String ? '"' : '';
      final delimiter = index++ < changes.length ? ',' : '';

      if (change.valueType == CsBlePacketValueType.array) {
        final List<int> value = change.value;
        final arrayString = StringBuffer('[');
        int arrayIndex = 1;

        for (var i = 0; i < value.length; i++) {
          final arrayDelimiter = arrayIndex++ < value.length ? ',' : '';
          arrayString.write('$arrayString${value[i]}$arrayDelimiter ');
        }

        json = '$json"${change.key}":${arrayString.toString().trim()}]$delimiter ';
      } else {
        json = '$json"${change.key}":$valueQuote${change.value}$valueQuote$delimiter ';
      }
    }

    return '${json.trim()}}';
  }
}
