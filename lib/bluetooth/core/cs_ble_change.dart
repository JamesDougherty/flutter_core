import 'package:flutter/foundation.dart';

@immutable
class CsBleChange {
  final String key;
  final dynamic value;

  const CsBleChange({required this.key, required this.value});
}
