import 'package:flutter_blue_plus/flutter_blue_plus.dart';

extension CsScanResultExt on ScanResult {
  ///
  /// Chandler Systems, Inc. Assigned Company Identifier
  ///
  /// See [Company Identifiers](https://www.bluetooth.com/specifications/assigned-numbers/company-identifiers/) for
  /// more information.
  ///
  static const int _csiCompanyIdentifier = 0x073A;

  ///
  /// Determines if the [ScanResult] is for a Chandler Systems, Inc. device or not.
  ///
  /// **Returns**
  /// `true` if the [ScanResult] is for a Chandler Systems, Inc. device, `false` otherwise.
  ///
  bool get isCsiDevice {
    if (advertisementData.manufacturerData.isEmpty) {
      return false;
    }

    final manufacturerData = advertisementData.manufacturerData;
    final int rawManufacturerId = manufacturerData.keys.first;

    return rawManufacturerId == _csiCompanyIdentifier;
  }
}
