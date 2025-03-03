import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CsUtilities {
  ///
  /// Convert an exception to a string that can be used for logging.
  ///
  /// **Parameters**
  ///  - [prefix]: The prefix to add to the exception string.
  /// - [exception]: The exception to convert to a string.
  ///
  /// **Returns**
  /// A string representation of the exception.
  ///
  static String exceptionToString(String prefix, dynamic exception) =>
      exception is FlutterBluePlusException
          ? '$prefix ${exception.description}'
          : exception is PlatformException
          ? '$prefix ${exception.message}'
          : prefix + exception.toString();

  ///
  /// Convert a buffer to a string that can be used for logging. The buffer is displayed in hex and ASCII.
  ///
  /// **Parameters**
  ///  - [prefix]: The prefix to add to the buffer string.
  /// - [buffer]: The buffer to convert to a string.
  ///
  /// **Returns**
  /// A string representation of the buffer.
  ///
  /// **Example**
  /// ```dart
  /// CsLog.d(CsUtilities.bufferToString('Buffer:', [ 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39 ]));
  ///
  /// // Output: Buffer: [ 10]: [30 31 32 33 34 35 36 37 38 39] [0 1 2 3 4 5 6 7 8 9]
  /// ```
  ///
  static String bufferToString(String? prefix, List<int> buffer) {
    if (buffer.isEmpty || !kDebugMode) {
      return '';
    }

    final bufferString = StringBuffer();
    final hexValues = StringBuffer();
    final asciiValues = StringBuffer();
    final internalPrefix = prefix == null ? '' : '$prefix ';
    final lengthDisplay = buffer.length.toString().padLeft(3);

    for (int i = 0; i < buffer.length; i++) {
      if (buffer[i] >= 33 && buffer[i] <= 126) {
        asciiValues.write('${String.fromCharCode(buffer[i])} ');
      } else {
        asciiValues.write(' ');
      }

      hexValues.write('${buffer[i].toRadixString(16).padLeft(2, '0')} ');
    }

    final hex = hexValues.toString().trim();
    final ascii = asciiValues.toString().trim();

    bufferString.writeln('$internalPrefix[$lengthDisplay]: [$hex] [$ascii]');

    return bufferString.toString();
  }

  ///
  /// Method used to count the number of bits set in a value. For instance, the value 5 (0b00000101) has 2 bits set.
  ///
  /// **Parameters**
  /// - [value]: The value to count the number of bits set.
  ///
  /// **Returns**
  /// - The number of bits set in the value.
  ///
  static int countSetBits(int value) {
    var workValue = value;
    var count = 0;

    while (workValue > 0) {
      count += workValue & 1;
      workValue = workValue >> 1;
    }

    return count;
  }

  ///
  /// Method used to convert a short value to a byte array.
  ///
  /// **Parameters**
  /// - [value]: The value to convert to a byte array.
  ///
  /// **Returns**
  /// - A byte array containing the short value.
  ///
  static List<int> shortToByteArray(int value) {
    return [
      (value >> 8) & 0xFF,
      value & 0xFF,
    ];
  }

  ///
  /// Method used to convert an int value to a byte array.
  ///
  /// **Parameters**
  /// - [value]: The value to convert to a byte array.
  ///
  /// **Returns**
  /// - A byte array containing the int value.
  /// 
  static List<int> intToByteArray(int value) {
    return [
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ];
  }
}
