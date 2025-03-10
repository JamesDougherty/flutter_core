import 'package:flutter/foundation.dart';

@immutable
class CsBlePacketRxChange<T> {
  final T key;
  final dynamic value;

  ///
  /// Constructor for the [CsBlePacketRxChange] class.
  ///
  /// **Parameters**
  /// - [T] key: The key to identify the change.
  /// - [dynamic] value: The value of the change.
  ///
  const CsBlePacketRxChange({required this.key, required this.value});
}
