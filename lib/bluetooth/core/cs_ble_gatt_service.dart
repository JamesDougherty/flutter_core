import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CsBleGattService {
  ///
  /// The UUID of the GATT service.
  ///
  Guid serviceUuid;

  ///
  /// The UUID of the characteristic used for reading data.
  ///
  Guid readCharacteristicUuid;

  ///
  /// The UUID of the characteristic used for writing data.
  ///
  Guid writeCharacteristicUuid;

  ///
  /// Constructor for the [CsBleGattService] class.
  ///
  /// **Parameters:**
  /// - `serviceUuid`: The UUID of the service.
  /// - `readCharacteristicUuid`: The UUID of the characteristic used for reading data.
  /// - `writeCharacteristicUuid`: The UUID of the characteristic used for writing data.
  ///
  /// Example:
  /// ```dart
  /// CsBleGattService(
  ///  serviceUuid: Guid('0000180d-0000-1000-8000-00805f9b34fb'),
  ///  readCharacteristicUuid: Guid('00002a37-0000-1000-8000-00805f9b34fb'),
  ///  writeCharacteristicUuid: Guid('00002a38-0000-1000-8000-00805f9b34fb'),
  /// );
  /// ```
  ///
  CsBleGattService({
    required this.serviceUuid,
    required this.readCharacteristicUuid,
    required this.writeCharacteristicUuid,
  });

  @override
  String toString() {
    return '''
      CsBleGattService(
        Service UUID: $serviceUuid
        Read Characteristic UUID: $readCharacteristicUuid
        Write Characteristic UUID: $writeCharacteristicUuid
      )
    ''';
  }
}
