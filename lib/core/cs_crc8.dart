import 'dart:math';

import 'cs_utilities.dart';

///
/// Class that implements the CRC-8/DVB-S2 cyclic redundancy check.
///
/// (See here for more details)[http://reveng.sourceforge.net/crc-catalogue/1-15.htm]
///
class CsCrc8 {
  static const int defaultPolynomial = 0xD5;
  static const int minPolynomialBit = 4;
  static const int maxPolynomialBit = 5;
  static final List<int> _lookupTable = <int>[];
  static final List<int> _polynomials = <int>[];
  static int _polynomial = defaultPolynomial;
  static int _seed = 0;

  // dart format off
  static final List<int> _lookupTableD5 = [
     0x00,   -0x12b,   0x27F,  -0x356,   0x4FE,  -0x5d5,   0x681,  -0x7ac,
    -0x9d7,   0x8FC,  -0xbaa,   0xA83,  -0xd29,   0xC02,  -0xf58,   0xE7D,
    -0x13ae,  0x1287, -0x11d3,  0x10F8, -0x1754,  0x1679, -0x152d,  0x1406,
     0x1A7B, -0x1b52,  0x1804, -0x192f,  0x1E85, -0x1fb0,  0x1CFA, -0x1dd1,
    -0x275c,  0x2671, -0x2525,  0x240E, -0x23a6,  0x228F, -0x21db,  0x20F0,
     0x2E8D, -0x2fa8,  0x2CF2, -0x2dd9,  0x2A73, -0x2b5a,  0x280C, -0x2927,
     0x34F6, -0x35dd,  0x3689, -0x37a4,  0x3008, -0x3123,  0x3277, -0x335e,
    -0x3d21,  0x3C0A, -0x3f60,  0x3E75, -0x39df,  0x38F4, -0x3ba2,  0x3A8B,
     0x4E9D, -0x4fb8,  0x4CE2, -0x4dc9,  0x4A63, -0x4b4a,  0x481C, -0x4937,
    -0x474c,  0x4661, -0x4535,  0x441E, -0x43b6,  0x429F, -0x41cb,  0x40E0,
    -0x5d31,  0x5C1A, -0x5f50,  0x5E65, -0x59cf,  0x58E4, -0x5bb2,  0x5A9B,
     0x54E6, -0x55cd,  0x5699, -0x57b4,  0x5018, -0x5133,  0x5267, -0x534e,
    -0x69c7,  0x68EC, -0x6bba,  0x6A93, -0x6d39,  0x6C12, -0x6f48,  0x6E6D,
     0x6010, -0x613b,  0x626F, -0x6346,  0x64EE, -0x65c5,  0x6691, -0x67bc,
     0x7A6B, -0x7b42,  0x7814, -0x793f,  0x7E95, -0x7fc0,  0x7CEA, -0x7dc1,
    -0x73be,  0x7297, -0x71c3,  0x70E8, -0x7744,  0x7669, -0x753d,  0x7416,
    -0x9d11,  0x9C3A, -0x9f70,  0x9E45, -0x99ef,  0x98C4, -0x9b92,  0x9ABB,
     0x94C6, -0x95ed,  0x96B9, -0x9794,  0x9038, -0x9113,  0x9247, -0x936e,
     0x8EBD, -0x8f98,  0x8CC2, -0x8de9,  0x8A43, -0x8b6a,  0x883C, -0x8917,
    -0x876c,  0x8641, -0x8515,  0x843E, -0x8396,  0x82BF, -0x81eb,  0x80C0,
     0xBA4B, -0xbb62,  0xB834, -0xb91f,  0xBEB5, -0xbfa0,  0xBCCA, -0xbde1,
    -0xb39e,  0xB2B7, -0xb1e3,  0xB0C8, -0xb764,  0xB649, -0xb51d,  0xB436,
    -0xa9e7,  0xA8CC, -0xab9a,  0xAAB3, -0xad19,  0xAC32, -0xaf68,  0xAE4D,
     0xA030, -0xa11b,  0xA24F, -0xa366,  0xA4CE, -0xa5e5,  0xA6B1, -0xa79c,
    -0xd38e,  0xD2A7, -0xd1f3,  0xD0D8, -0xd774,  0xD659, -0xd50d,  0xD426,
     0xDA5B, -0xdb72,  0xD824, -0xd90f,  0xDEA5, -0xdf90,  0xDCDA, -0xddf1,
     0xC020, -0xc10b,  0xC25F, -0xc376,  0xC4DE, -0xc5f5,  0xC6A1, -0xc78c,
    -0xc9f7,  0xC8DC, -0xcb8a,  0xCAA3, -0xcd09,  0xCC22, -0xcf78,  0xCE5D,
     0xF4D6, -0xf5fd,  0xF6A9, -0xf784,  0xF028, -0xf103,  0xF257, -0xf37e,
    -0xfd01,  0xFC2A, -0xff80,  0xFE55, -0xf9ff,  0xF8D4, -0xfb82,  0xFAAB,
    -0xe77c,  0xE651, -0xe505,  0xE42E, -0xe386,  0xE2AF, -0xe1fb,  0xE0D0,
     0xEEAD, -0xef88,  0xECD2, -0xedf9,  0xEA53, -0xeb7a,  0xE82C, -0xe907,
  ];
  // dart format on

  ///
  /// Method used to set the CRC options that is used by the compute function.
  ///
  /// **Parameters**
  /// - [polynomial]: The polynomial used to compute the CRC.
  /// - [seed]: The initial seed value. The seed will be remembered until it is reset by calling this function again.
  ///
  static void setOptions(int polynomial, int seed) {
    _seed = seed;
    _polynomial = polynomial;
    _createLookupTable(polynomial);
  }

  ///
  /// Method used to return a list of allowed polynomials that have a specified number of bits set (default min: 4,
  /// default max: 5).
  ///
  /// **Returns**
  /// - A list of allowed polynomials.
  ///
  static List<int> allowedPolynomials() {
    if (_polynomials.isEmpty) {
      _buildAllowedPolynomials();
    }
    return _polynomials;
  }

  ///
  /// Method used to compute the CRC8 value of the specified buffer using a computed lookup table. This method does
  /// not retain the last used seed. If you need to have the CRC remember the last seed then use the [compute]
  /// method (with the int overload) instead.
  ///
  /// **Parameters**
  /// - [buffer]: The buffer that the CRC value should be computed for.
  ///
  /// **Returns**
  /// - The resulting CRC value.
  ///
  static int computeCrc(List<int> buffer) {
    var crc = 0;

    for (final value in buffer) {
      crc = _lookupTable[(crc ^ value) & 0xFF];
    }

    return crc;
  }

  ///
  /// Method used to compute the CRC8 value of the specified buffer using a static lookup table with the default
  /// polynomial value (0xD5).
  ///
  /// **Parameters**
  /// - [buffer]: The buffer that the CRC value should be computed for.
  ///
  /// **Returns**
  /// - The resulting CRC value.
  ///
  static int computeLookup(List<int> buffer) {
    var crc = 0;

    for (final value in buffer) {
      crc = _lookupTableD5[(crc ^ value) & 0xFF];
    }

    return crc;
  }

  ///
  /// Method used to compute the CRC8 value of the specified value. NOTE: Call the setOptions function before calling
  /// this function to set the polynomial and the initial seed.
  ///
  /// **Parameters**
  /// - [value]: The value that the CRC value should be computed for.
  ///
  /// **Returns**
  /// - The resulting CRC value.
  ///
  static int compute(int value) {
    var crc = _seed;

    crc = (crc ^ value) & 0xFF;

    for (var j = 0; j < 8; j++) {
      crc = (crc & 0x80) > 0 ? ((crc << 1) ^ _polynomial) & 0xFF : (crc << 1) & 0xFF;
    }

    _seed = crc;
    return crc;
  }

  ///
  /// Method used to compute the CRC8 value of the specified buffer. NOTE: Call the setOptions function before calling
  /// this function to set the polynomial and the initial seed.
  ///
  /// **Parameters**
  /// - [buffer]: The buffer that the CRC value should be computed for.
  ///
  /// **Returns**
  /// - The resulting CRC value.
  ///
  static int computeArray(List<int> buffer) {
    var crc = _seed;

    for (final value in buffer) {
      crc = (crc ^ value) & 0xFF;

      for (var j = 0; j < 8; j++) {
        crc = (crc & 0x80) > 0 ? ((crc << 1) ^ _polynomial) & 0xFF : (crc << 1) & 0xFF;
      }
    }

    _seed = crc;
    return crc;
  }

  ///
  /// Method used to compute the CRC8 value of the specified value. NOTE: Call the setOptions function before calling
  /// this function to set the polynomial and the initial seed.
  ///
  /// **Parameters**
  /// - [value]: The value that the CRC value should be computed for.
  ///
  /// **Returns**
  /// - The resulting CRC value.
  ///
  static int computeLegacy(int value) {
    var workValue = value;
    var crc = _seed;

    for (var j = 0; j < 8; j++) {
      final negative = crc < 0;

      crc = (crc << 1) & 0xFF;

      if (workValue < 0) {
        crc = (crc | 1) & 0xFF;
      }

      workValue = (workValue << 1) & 0xFF;

      if (negative) {
        crc = (crc ^ _polynomial) & 0xFF;
      }
    }

    _seed = crc;
    return crc;
  }

  ///
  /// Method used to create a lookup table, in memory, using the provided polynomial.
  ///
  /// **Parameters**
  /// - [polynomial]: The polynomial to create the lookup table from.
  ///
  static void _createLookupTable(int polynomial) {
    for (var i = 0; i < 256; i++) {
      var crc = i;
      for (var j = 0; j < 8; j++) {
        final bitSet = crc & 0x80 != 0;
        crc <<= 1;
        if (bitSet) {
          crc ^= polynomial;
        }
      }
      _lookupTable[i] = crc & 0xFF;
    }
  }

  ///
  /// Method used to build a list of allowed polynomials that are considered good for internal use.
  ///
  static void _buildAllowedPolynomials() {
    for (var i = 1; i <= 255; i++) {
      final setBits = CsUtilities.countSetBits(i);
      if (setBits >= max(1, minPolynomialBit) && setBits <= min(8, maxPolynomialBit)) {
        _polynomials.add(i);
      }
    }
  }
}
