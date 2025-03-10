import '../../../../bluetooth/core/cs_ble_packet_rx_change.dart';
import '../../../../core/cs_active_state.dart';
import '../../../../core/cs_am_pm.dart';
import '../../../../core/cs_brine_tank.dart';
import '../../../../core/cs_log.dart';
import '../../../../core/cs_measurement.dart';
import '../../../../core/cs_unit_conversion.dart';
import '../../../../core/cs_unit_conversion_type.dart';
import '../../../core/cs_device_auth_state.dart';
import 'cs_valve_evb034_packet_keys.dart';
import 'cs_valve_evb034_position_options.dart';
import 'cs_valve_evb034_regen_state.dart';
import 'cs_valve_evb034_regen_time_type.dart';
import 'cs_valve_evb034_series.dart';
import 'cs_valve_evb034_type.dart';
import 'cs_valve_evb034_type_full.dart';

class CsValveEvb034Packet {
  CsMeasurement measurement = CsMeasurement.standard;

  //Auth
  CsDeviceAuthState authState = CsDeviceAuthState.unauthenticated;

  //Device List
  int dlSerialNumberA = 0;
  int dlSerialNumberB = 0;
  int dlFirmwareVersion = 0;
  bool dlRegenMotorInProgress = false;
  bool dlIsTwinValve = false;
  bool dlIsClackValve = false;
  CsValveEvb034Type dlValveType = CsValveEvb034Type.unknown;
  CsValveEvb034TypeFull dlValveTypeFull = CsValveEvb034TypeFull.unknown;
  CsValveEvb034Series dlValveSeries = CsValveEvb034Series.unknown;
  int dlConnectionCounter = 0;

  // Dashboard
  int dbHours = 0;
  int dbMinutes = 0;
  int dbSeconds = 0;
  CsAmPm dbAmPm = CsAmPm.am;
  int dbBatteryLevel = 0;
  int dbTotalGallonsRemaining = 0;
  double dbPeakFlowDaily = 0;
  int dbWaterHardness = 0;
  int dbDayOverride = 0;
  double dbWaterUsedToday = 0;
  int dbCurrentDayOverride = 0;
  int dbRegenTimeHours = 0;
  int dbRegenTimeMinutes = 0;
  CsAmPm dbRegenTimeAmPm = CsAmPm.am;
  int dbRegenTimeRemaining = 0;
  CsValveEvb034RegenTimeType dbRegenTimeType = CsValveEvb034RegenTimeType.minutes;
  int dbRegenCurrentPosition = 0;
  bool dbRegenInAeration = false;
  int dbRegenSoakTimer = 0;
  bool dbPrefillEnabled = false;
  int dbPrefillDuration = 0;
  bool dbPrefillSoakMode = false;
  bool dbBrineTankIsSetup = false;
  CsBrineTank dbBrineTankWidth = CsBrineTank.unknown;
  int dbBrineTankFillHeight = 0;
  int dbBrineTankRefillTime = 0;
  int dbBrineTankRegensRemaining = 0;
  int dbBrineTankTotalSaltPounds = 0;
  int dbBrineTankRemainingSaltPounds = 0;
  double dbAvgWaterUsed = 0;

  // Advanced Settings
  int asDaysUntilRegen = 0;
  int asRegenDayOverride = 0;
  int asReserveCapacity = 0;
  int asTotalGrainsCapacity = 0;
  int asAerationDays = 0;
  int asChlorinePulses = 0;
  CsActiveState asDisplayOff = CsActiveState.inactive;
  int asNumPositions = 0;
  List<int> asPositionTimes = [];
  List<CsValveEvb034PositionOptions> asPositionOptions = [];

  // Status & History
  int shRegenCounter = 0;
  int shRegenCounterResettable = 0;
  double shGallonsTotalizer = 0;
  double shGallonsTotalizerResettable = 0;

  // Dealer Information
  String diName = '';
  String diPhone = '';
  String diAddress1 = '';
  String diAddress2 = '';
  String diEmail = '';
  String diWeb = '';

  // Graphs
  List<double> grPeakFlowDaily = List.filled(62, 0);
  List<double> grGallonsUsedDaily = List.filled(62, 0);
  List<double> grGallonsUsedBetweenRegens = List.filled(42, 0);

  // Global
  int glValveStatus = 0;
  double glPresentFlow = 0;
  bool glLeaseModeEnabled = false;
  bool glLeaseModeActive = false;
  bool glRegenActive = false;
  CsValveEvb034RegenState glRegenState = CsValveEvb034RegenState.idle;
  bool glBatteryReadEnabled = false;

  // Test Mode
  bool tmRunning = false;
  int tmCounter = 0;
  int tmStatusBits = 0;
  int tmErrorBits = 0;

  // Other
  bool dataFullyLoaded = false;

  void reset() {
    // Auth
    authState = CsDeviceAuthState.unauthenticated;

    // Device List
    dlSerialNumberA = 0;
    dlSerialNumberB = 0;
    dlFirmwareVersion = 0;
    dlRegenMotorInProgress = false;
    dlIsTwinValve = false;
    dlIsClackValve = false;
    dlValveType = CsValveEvb034Type.unknown;
    dlValveTypeFull = CsValveEvb034TypeFull.unknown;
    dlValveSeries = CsValveEvb034Series.unknown;
    dlConnectionCounter = 0;

    // Dashboard
    dbHours = 0;
    dbMinutes = 0;
    dbSeconds = 0;
    dbAmPm = CsAmPm.am;
    dbBatteryLevel = 0;
    dbTotalGallonsRemaining = 0;
    dbPeakFlowDaily = 0;
    dbWaterHardness = 0;
    dbDayOverride = 0;
    dbWaterUsedToday = 0;
    dbCurrentDayOverride = 0;
    dbAvgWaterUsed = 0;
    dbRegenTimeHours = 0;
    dbRegenTimeMinutes = 0;
    dbRegenTimeAmPm = CsAmPm.am;
    dbRegenTimeRemaining = 0;
    dbRegenTimeType = CsValveEvb034RegenTimeType.minutes;
    dbRegenCurrentPosition = 0;
    dbRegenInAeration = false;
    dbRegenSoakTimer = 0;
    dbPrefillEnabled = false;
    dbPrefillDuration = 0;
    dbPrefillSoakMode = false;
    dbBrineTankIsSetup = false;
    dbBrineTankWidth = CsBrineTank.unknown;
    dbBrineTankFillHeight = 0;
    dbBrineTankRefillTime = 0;
    dbBrineTankRegensRemaining = 0;
    dbBrineTankTotalSaltPounds = 0;
    dbBrineTankRemainingSaltPounds = 0;

    // Advanced Settings
    asDaysUntilRegen = 0;
    asRegenDayOverride = 0;
    asReserveCapacity = 0;
    asTotalGrainsCapacity = 0;
    asAerationDays = 0;
    asChlorinePulses = 0;
    asDisplayOff = CsActiveState.inactive;
    asNumPositions = 0;
    asPositionTimes = [];
    asPositionOptions = [];
    asPositionOptions.clear();

    // Status & History
    shRegenCounter = 0;
    shRegenCounterResettable = 0;
    shGallonsTotalizer = 0;
    shGallonsTotalizerResettable = 0;

    // Dealer Information
    diName = '';
    diPhone = '';
    diAddress1 = '';
    diAddress2 = '';
    diEmail = '';
    diWeb = '';

    // Graphs
    grPeakFlowDaily = List.filled(62, 0);
    grGallonsUsedDaily = List.filled(62, 0);
    grGallonsUsedBetweenRegens = List.filled(42, 0);

    // Global
    glValveStatus = 0;
    glPresentFlow = 0;
    glLeaseModeEnabled = false;
    glLeaseModeActive = false;
    glRegenActive = false;
    glRegenState = CsValveEvb034RegenState.idle;
    glBatteryReadEnabled = false;

    // Test Mode
    tmRunning = false;
    tmCounter = 0;
    tmStatusBits = 0;
    tmErrorBits = 0;

    // Other
    dataFullyLoaded = false;
  }

  static CsValveEvb034Packet update(
    CsValveEvb034Packet packet,
    List<CsBlePacketRxChange<CsValveEvb034PacketKeys>> changes,
  ) {
    if (changes.isEmpty) {
      return packet;
    }

    changes.sort((a, b) => a.key.compareTo(b.key));

    for (final change in changes) {
      final key = change.key;
      final value = change.value;

      if (value == null) {
        continue;
      }

      if (value is List) {
        switch (key) {
          // Advanced Settings Keys
          case CsValveEvb034PacketKeys.asPositionTimes:
            packet.asPositionTimes = List<int>.from(value);

          case CsValveEvb034PacketKeys.asPositionOptions:
            final options = List<int>.from(value);
            for (final option in options) {
              packet.asPositionOptions.add(CsValveEvb034PositionOptions.fromInt(option));
            }

          // Dealer Information Keys
          case CsValveEvb034PacketKeys.diName:
            packet.diName = value.join();

          case CsValveEvb034PacketKeys.diPhone:
            packet.diPhone = value.join();

          case CsValveEvb034PacketKeys.diAddress1:
            packet.diAddress1 = value.join();

          case CsValveEvb034PacketKeys.diAddress2:
            packet.diAddress2 = value.join();

          case CsValveEvb034PacketKeys.diEmail:
            packet.diEmail = value.join();

          case CsValveEvb034PacketKeys.diWeb:
            packet.diWeb = value.join();
            packet.dataFullyLoaded = true;

          // Graph Keys
          case CsValveEvb034PacketKeys.grPeakFlowDaily:
            _convertPeakFlowGraph(packet, List<int>.from(value));

          case CsValveEvb034PacketKeys.grGallonsUsedDaily:
            _convertGallonsUsedDailyGraph(packet, List<int>.from(value));

          case CsValveEvb034PacketKeys.grGallonsUsedBetweenRegens:
            _convertGallonsUsedBetweenRegensGraph(packet, List<int>.from(value));

          default:
            CsLog.d('[CsValveEvb034Packet Update] -- Array Key Unhandled: $key');
        }

        continue;
      }

      switch (key) {
        // Auth Keys
        case CsValveEvb034PacketKeys.authState:
          packet.authState = CsDeviceAuthState.fromInt(value);

        // Device List Keys
        case CsValveEvb034PacketKeys.dlSerialNumberA:
          packet.dlSerialNumberA = value;

        case CsValveEvb034PacketKeys.dlSerialNumberB:
          packet.dlSerialNumberB = value;

        case CsValveEvb034PacketKeys.dlFirmwareVersion:
          packet.dlFirmwareVersion = value;

        case CsValveEvb034PacketKeys.dlRegenMotorInProgress:
          packet.dlRegenMotorInProgress = value == 1;

        case CsValveEvb034PacketKeys.dlIsTwinValve:
          packet.dlIsTwinValve = value == 1;

        case CsValveEvb034PacketKeys.dlIsClackValve:
          packet.dlIsClackValve = value == 1;

        case CsValveEvb034PacketKeys.dlValveType:
          packet.dlValveType = CsValveEvb034Type.fromValveType(value);
          packet.dlValveTypeFull = CsValveEvb034TypeFull.fromInt(value);

        case CsValveEvb034PacketKeys.dlValveSeries:
          packet.dlValveSeries = CsValveEvb034Series.fromInt(value);

        case CsValveEvb034PacketKeys.dlConnectionCounter:
          packet.dlConnectionCounter = value;

        // Dashboard Keys
        case CsValveEvb034PacketKeys.dbHours:
          packet.dbHours = value;

        case CsValveEvb034PacketKeys.dbMinutes:
          packet.dbMinutes = value;

        case CsValveEvb034PacketKeys.dbSeconds:
          packet.dbSeconds = value;

        case CsValveEvb034PacketKeys.dbAmPm:
          packet.dbAmPm = CsAmPm.fromInt(value);

        case CsValveEvb034PacketKeys.dbBatteryLevel:
          packet.dbBatteryLevel = _getBatteryCapacity((value as double) / 1000.0);

        case CsValveEvb034PacketKeys.dbTotalGallonsRemaining:
          packet.dbTotalGallonsRemaining = ((value as double) / _getFloatDivisor(packet)).toInt();

        case CsValveEvb034PacketKeys.dbPeakFlowDaily:
          packet.dbPeakFlowDaily = (value as int) / 100.0;

        case CsValveEvb034PacketKeys.dbWaterHardness:
          packet.dbWaterHardness = value;

        case CsValveEvb034PacketKeys.dbDayOverride:
          packet.dbDayOverride = value;

        case CsValveEvb034PacketKeys.dbWaterUsedToday:
          packet.dbWaterUsedToday = (value as double) / _getFloatDivisor(packet);

        case CsValveEvb034PacketKeys.dbAvgWaterUsed:
          packet.dbAvgWaterUsed = (value as double) / 100.0;

        case CsValveEvb034PacketKeys.dbCurrentDayOverride:
          packet.dbCurrentDayOverride = value;

        case CsValveEvb034PacketKeys.dbRegenTimeHours:
          packet.dbRegenTimeHours = value;

        case CsValveEvb034PacketKeys.dbRegenTimeMinutes:
          packet.dbRegenTimeMinutes = value;

        case CsValveEvb034PacketKeys.dbRegenTimeAmPm:
          packet.dbRegenTimeAmPm = CsAmPm.fromInt(value);

        case CsValveEvb034PacketKeys.dbRegenTimeRemaining:
          packet.dbRegenTimeRemaining = value;

        case CsValveEvb034PacketKeys.dbRegenTimeType:
          packet.dbRegenTimeType = CsValveEvb034RegenTimeType.fromInt(value);

        case CsValveEvb034PacketKeys.dbRegenCurrentPosition:
          packet.dbRegenCurrentPosition = value;

        case CsValveEvb034PacketKeys.dbRegenInAeration:
          packet.dbRegenInAeration = value == 1;

        case CsValveEvb034PacketKeys.dbRegenSoakTimer:
          packet.dbRegenSoakTimer = value;

        case CsValveEvb034PacketKeys.dbPrefillEnabled:
          packet.dbPrefillEnabled = value == 1;

        case CsValveEvb034PacketKeys.dbPrefillDuration:
          packet.dbPrefillDuration = value;

        case CsValveEvb034PacketKeys.dbPrefillSoakMode:
          packet.dbPrefillSoakMode = value == 1;

        case CsValveEvb034PacketKeys.dbBrineTankWidth:
          packet.dbBrineTankWidth = CsBrineTank.fromInt(value);
          packet.dbBrineTankIsSetup = packet.dbBrineTankWidth != CsBrineTank.unknown;

        case CsValveEvb034PacketKeys.dbBrineTankFillHeight:
          packet.dbBrineTankFillHeight = value;

        case CsValveEvb034PacketKeys.dbBrineTankRefillTime:
          packet.dbBrineTankRefillTime = value;

        case CsValveEvb034PacketKeys.dbBrineTankTotalSaltPounds:
          packet.dbBrineTankTotalSaltPounds = value;

        case CsValveEvb034PacketKeys.dbBrineTankRemainingSaltPounds:
          if (packet.dlFirmwareVersion >= 611) {
            packet.dbBrineTankRemainingSaltPounds = ((value as double) / 10.0).round();
          } else {
            packet.dbBrineTankRemainingSaltPounds = value;
          }

        // Advanced Settings Keys
        case CsValveEvb034PacketKeys.asDaysUntilRegen:
          packet.asDaysUntilRegen = value;

        case CsValveEvb034PacketKeys.asRegenDayOverride:
          packet.asRegenDayOverride = value;

        case CsValveEvb034PacketKeys.asReserveCapacity:
          packet.asReserveCapacity = value;

        case CsValveEvb034PacketKeys.asTotalGrainsCapacity:
          packet.asTotalGrainsCapacity = value;

        case CsValveEvb034PacketKeys.asAerationDays:
          packet.asAerationDays = value;

        case CsValveEvb034PacketKeys.asChlorinePulses:
          packet.asChlorinePulses = value;

        case CsValveEvb034PacketKeys.asDisplayOff:
          packet.asDisplayOff = CsActiveState.fromInt(value);

        case CsValveEvb034PacketKeys.asNumPositions:
          packet.asNumPositions = value;

        // Status & History Keys
        case CsValveEvb034PacketKeys.shRegenCounter:
          packet.shRegenCounter = value;

        case CsValveEvb034PacketKeys.shRegenCounterResettable:
          packet.shRegenCounterResettable = value;

        case CsValveEvb034PacketKeys.shGallonsTotalizer:
          packet.shGallonsTotalizer = (value as int) / _getFloatDivisor(packet);

        case CsValveEvb034PacketKeys.shGallonsTotalizerResettable:
          packet.shGallonsTotalizerResettable = (value as int) / _getFloatDivisor(packet);

        // Global Keys
        case CsValveEvb034PacketKeys.glValveStatus:
          packet.glValveStatus = value;

        case CsValveEvb034PacketKeys.glPresentFlow:
          packet.glPresentFlow = (value as int) / 100.0;

        case CsValveEvb034PacketKeys.glLeaseModeEnabled:
          packet.glLeaseModeEnabled = value == 1;

        case CsValveEvb034PacketKeys.glLeaseModeActive:
          packet.glLeaseModeActive = value == 1;

        case CsValveEvb034PacketKeys.glRegenActive:
          packet.glRegenActive = value == 1;

        case CsValveEvb034PacketKeys.glRegenState:
          packet.glRegenState = CsValveEvb034RegenState.fromInt(value);

        case CsValveEvb034PacketKeys.glBatteryReadEnabled:
          packet.glBatteryReadEnabled = value == 1;

        // Test Mode Keys
        case CsValveEvb034PacketKeys.tmCounter:
          packet.tmCounter = value;

        case CsValveEvb034PacketKeys.tmRunning:
          packet.tmRunning = value == 1;

        case CsValveEvb034PacketKeys.tmStatusBits:
          packet.tmStatusBits = value;

        case CsValveEvb034PacketKeys.tmErrorBits:
          packet.tmErrorBits = value;

        default:
          CsLog.d('[CsValveEvb034Packet Update] -- Key Unhandled: $key');
      }
    }

    CsLog.d('[CsValveEvb034Packet Update] -- Packet Updated: $packet');

    return packet;
  }

  static double _getFloatDivisor(CsValveEvb034Packet packet) => packet.dlFirmwareVersion >= 611 ? 100.0 : 1.0;

  static int _getBatteryCapacity(double value) {
    if (value >= 9.5) {
      return 100;
    } else if (value >= 8.91) {
      return (100 - (9.5 - value) * 8.78).toInt();
    } else if (value >= 8.48) {
      return (94.78 - (8.91 - value) * 30.26).toInt();
    } else if (value >= 7.43) {
      return (81.84 - (8.48 - value) * 60.47).toInt();
    } else if (value >= 6.5) {
      return (18.68 - (7.43 - value) * 20.02).toInt();
    } else {
      return 0;
    }
  }

  static void _convertPeakFlowGraph(CsValveEvb034Packet packet, List<int> graphData) {
    var index = 0;

    for (final value in graphData) {
      final standardValue = value.toDouble() / 100.0;

      packet.grPeakFlowDaily[index++] =
          packet.measurement == CsMeasurement.standard
              ? standardValue
              : CsUnitConversion.convertToMetric(CsUnitConversionType.gpm, standardValue);
    }
  }

  static void _convertGallonsUsedDailyGraph(CsValveEvb034Packet packet, List<int> graphData) {
    var index = 0;

    if (packet.dlFirmwareVersion < 611) {
      packet.dbAvgWaterUsed = _computeAveragePerDayWaterUsage(graphData);
    }

    for (final dataPoint in graphData) {
      final value = dataPoint.toDouble() / _getFloatDivisor(packet);

      packet.grGallonsUsedDaily[index++] =
          packet.measurement == CsMeasurement.standard
              ? value
              : CsUnitConversion.convertToMetric(CsUnitConversionType.gallons, value);
    }
  }

  static void _convertGallonsUsedBetweenRegensGraph(CsValveEvb034Packet packet, List<int> graphData) {
    var index = 0;

    for (final dataPoint in graphData) {
      final value = dataPoint.toDouble() / _getFloatDivisor(packet);

      packet.grGallonsUsedBetweenRegens[index++] =
          packet.measurement == CsMeasurement.standard
              ? value
              : CsUnitConversion.convertToMetric(CsUnitConversionType.gallons, value);
    }
  }

  static double _computeAveragePerDayWaterUsage(List<int> graphData) {
    final start = graphData.length - 1;
    final end = graphData.length ~/ 2 - 1; // Last 30 days only
    var samples = 0;
    var sum = 0.0;

    for (var i = start; i >= end; i--) {
      if (graphData[i] != 0) {
        sum += graphData[i].toDouble() / 100.0;
        samples++;
      }
    }

    return samples > 0 ? sum / samples : 0.0;
  }
}
