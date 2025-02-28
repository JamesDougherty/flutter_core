
extension CsIntExt on int {
  ///
  /// Method to convert an integer to a list of bits.
  ///
  /// **Parameters:**
  /// - `bitCount`: The number of bits to convert the integer to. Default is 8.
  ///
  /// **Returns**
  /// - A [List] of [int] containing the bits of the integer.
  ///
  /// **Example**
  /// ```dart
  /// final int value = 5;
  /// final List<int> bits = value.intToBits();
  /// print(bits); // [0, 0, 0, 0, 0, 1, 0, 1]
  /// ```
  ///
  List<int> toBits({int bitCount = 8}) {
    final List<int> bits = List.filled(bitCount, 0);
    for (int i = 0; i < bitCount; i++) {
      bits[bitCount - i - 1] = (this >> i) & 1;
    }
    return bits;
  }

  ///
  /// Method to convert an integer to a list of boolean bits.
  ///
  /// **Parameters:**
  /// - `bitCount`: The number of bits to convert the integer to. Default is 8.
  ///
  /// **Returns**
  /// - A [List] of [bool] containing the bits of the integer.
  ///
  /// **Example**
  /// ```dart
  /// final int value = 5;
  /// final List<bool> bits = value.toBoolBits();
  /// print(bits); // [false, false, false, false, false, true, false, true]
  /// ```
  ///
  List<bool> toBoolBits({int bitCount = 8}) {
    return toBits(bitCount: bitCount).map((bit) => bit == 1).toList();
  }
}
