import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'bluetooth/cs_ble.dart';
import 'bluetooth/cs_ble_scanner.dart';
import 'core/cs_log.dart';
import 'core/cs_shared_preferences.dart';
import 'device_manager/cs_device_manager.dart';
import 'device_manager/devices/valve_evb034/cs_valve_evb034.dart';

//
// Export all the classes and methods from the library *that need to be exposed*. Not all classes and methods need to
// be exposed. For instance, the Bluetooth RSSI average class is not exposed because it is only used internally by the
// BLE scanner.
//

export 'bluetooth/core/cs_ble_adapter_state.dart';
export 'bluetooth/core/cs_ble_connect_result.dart';
export 'bluetooth/core/cs_ble_connection_state.dart';
export 'bluetooth/core/cs_ble_device.dart';
export 'bluetooth/core/cs_ble_gatt_service.dart';
export 'bluetooth/core/cs_ble_json_packet.dart';
export 'bluetooth/core/cs_ble_packet.dart';
export 'bluetooth/core/cs_ble_packet_rx_change.dart';
export 'bluetooth/core/cs_ble_packet_tx_change.dart';
export 'bluetooth/core/cs_ble_packet_value_type.dart';
export 'bluetooth/core/cs_ble_process_data_type.dart';
export 'bluetooth/core/cs_ble_processor_ack_nak.dart';
export 'bluetooth/core/cs_ble_queue_entry.dart';
export 'bluetooth/core/cs_ble_scan_start_result.dart';
export 'bluetooth/cs_ble.dart';
export 'bluetooth/cs_ble_processor.dart';
export 'bluetooth/cs_ble_scanner.dart';
export 'bluetooth/extensions/cs_ble_device_ext.dart';
export 'bluetooth/extensions/cs_scan_result_ext.dart';
export 'branding/cs_branding_core_strings.dart';
export 'core/cs_active_state.dart';
export 'core/cs_am_pm.dart';
export 'core/cs_brine_tank.dart';
export 'core/cs_crc16.dart';
export 'core/cs_crc8.dart';
export 'core/cs_log.dart';
export 'core/cs_measurement.dart';
export 'core/cs_shared_preferences.dart';
export 'core/cs_unit_conversion.dart';
export 'core/cs_unit_conversion_type.dart';
export 'core/cs_utilities.dart';
export 'core/cs_variable_timer.dart';
export 'device_manager/core/cs_device.dart';
export 'device_manager/core/cs_device_auth_state.dart';
export 'device_manager/core/cs_device_base.dart';
export 'device_manager/core/cs_device_identifier.dart';
export 'device_manager/core/cs_device_type.dart';
export 'device_manager/cs_device_manager.dart';
export 'device_manager/devices/shared/cs_device_bypass_status.dart';
export 'device_manager/devices/shared/cs_device_salt_sensor_status.dart';
export 'device_manager/devices/shared/cs_device_water_status.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_adv_data.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_cycle_position.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_error_state.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_packet.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_packet_keys.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_packets.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_position_options.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_regen_state.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_regen_time_type.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_series.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_type.dart';
export 'device_manager/devices/valve_evb034/core/cs_valve_evb034_type_full.dart';
export 'device_manager/devices/valve_evb034/cs_valve_evb034.dart';
export 'extensions/cs_int_ext.dart';

class CsLib {
  ///
  /// Initialize the CsLib. This method should be called before using any other methods in the CsLib.
  ///
  static Future<void> initialize() async {
    await FlutterBluePlus.setLogLevel(kReleaseMode ? LogLevel.none : LogLevel.verbose);
    await CsSharedPreferences().initialize();
    await CsBle().initialize();
    await CsBleScanner().initialize();
    CsDeviceManager().registerDevice(CsValveEvb034().deviceIdentifier);
    CsLog.d('CsLib Initialized');
  }

  ///
  /// Dispose the CsLib. This method should be called when the CsLib is no longer needed.
  ///
  static Future<void> dispose() async {
    await CsBle().dispose();
    await CsBleScanner().dispose();
    CsLog.d('CsLib Disposed');
  }
}
