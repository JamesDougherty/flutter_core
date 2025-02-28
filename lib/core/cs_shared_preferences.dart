import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cs_log.dart';

class CsSharedPreferences {
  static final CsSharedPreferences _instance = CsSharedPreferences._internal();
  SharedPreferences? _preferences;

  factory CsSharedPreferences() {
    return _instance;
  }

  CsSharedPreferences._internal();

  ///
  /// Initialize the user preferences. This should be called before any other methods in this class.
  ///
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    CsLog.d('CsSharedPreferences initialized');
  }

  ///
  /// Get the device alias for the given device identifier.
  /// Returns null if no alias is set.
  ///
  /// **Parameters:**
  /// - `identifier`: The device identifier to get the alias for.
  ///
  /// **Returns**
  /// - A [Future] that resolves to a [String] containing the alias for the device if it's found; otherwise, it
  ///   resolves to `null`.
  ///
  String? getDeviceAlias(DeviceIdentifier? identifier) {
    assert(_preferences != null, 'CsSharedPreferences not initialized, call init() first');

    if (identifier == null) {
      return null;
    }

    final String value = _preferences?.getString(
      _CsSharedPreferencesKeys.deviceAliasPrefix + identifier.toString(),
    ) ?? '';

    if (value.isNotEmpty) {
      CsLog.d('Device alias found for $identifier [Alias: $value]');
    } else {
      CsLog.w('No device alias found for $identifier');
    }

    return value.isNotEmpty ? value : null;
  }

  ///
  /// Set the device alias for the given device identifier.
  ///
  /// **Parameters:**
  /// - `identifier`: The device identifier to set the alias for.
  /// - `alias`: The alias to set for the device.
  ///
  /// **Returns**
  /// - A [Future] that resolves when the alias has been set.
  ///
  Future<void> setDeviceAlias(DeviceIdentifier identifier, String alias) async {
    assert(_preferences != null, 'CsSharedPreferences not initialized, call init() first');

    final bool settingSet = await _preferences?.setString(
      _CsSharedPreferencesKeys.deviceAliasPrefix + identifier.toString(),
      alias,
    ) ?? false;

    if (settingSet) {
      CsLog.d('Device alias set for $identifier [Alias: $alias]');
    } else {
      CsLog.w('Failed to set device alias for $identifier [Alias: $alias]');
    }
  }

  ///
  /// Remove the device alias for the given device identifier.
  ///
  /// **Parameters:**
  /// - `identifier`: The device identifier to remove the alias for.
  ///
  Future<void> removeDeviceAlias(DeviceIdentifier identifier) async {
    assert(_preferences != null, 'CsSharedPreferences not initialized, call init() first');

    final bool settingRemoved = await _preferences?.remove(
      _CsSharedPreferencesKeys.deviceAliasPrefix + identifier.toString(),
    ) ?? false;

    if (settingRemoved) {
      CsLog.d('Device alias removed for $identifier');
    } else {
      CsLog.w('Failed to remove device alias for $identifier');
    }
  }
}

class _CsSharedPreferencesKeys {
  static const String deviceAliasPrefix = 'ALIAS-';
}
