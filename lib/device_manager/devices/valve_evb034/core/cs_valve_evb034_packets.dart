import 'dart:math';

import 'package:enumset/enumset.dart';

import '../../../../bluetooth/core/cs_ble_packet_tx_change.dart';
import '../../../../bluetooth/core/cs_ble_packet_value_type.dart';
import '../../../../bluetooth/core/cs_ble_processor_headers.dart';
import '../../../../core/cs_am_pm.dart';
import '../../../../core/cs_crc8.dart';
import 'cs_valve_evb034_cycle_position.dart';
import 'cs_valve_evb034_packet.dart';
import 'cs_valve_evb034_packet_keys.dart';
import 'cs_valve_evb034_position_options.dart';

class CsValveEvb034Packets {
  static final CsValveEvb034Packets _instance = CsValveEvb034Packets._internal();
  static final List<int> _allowedPolynomials = CsCrc8.allowedPolynomials();

  factory CsValveEvb034Packets() {
    return _instance;
  }

  CsValveEvb034Packets._internal();

  List<int> idPacket() => [
    CsBleProcessorHeaders.singlePacket |
        CsBleProcessorHeaders.keepAlive |
        CsBleProcessorHeaders.ackNak |
        CsBleProcessorHeaders.timeout,
  ];

  List<int> getPasswordBuffer(int mtu, int connectionCounter, int password) {
    final mtuFix = mtu; // Used to suppress unused warning, should always be 20 for now
    final rng = Random.secure();
    final randomBytes = List<int>.generate(mtuFix, (index) => rng.nextInt(256));

    final passwordBytes = getPasswordBytes(password);
    final result = List<int>.filled(mtuFix, 0);

    result.setRange(0, mtuFix, randomBytes);

    final polynomialIndex = rng.nextInt(_allowedPolynomials.length);
    final polynomial = _allowedPolynomials[polynomialIndex];
    final seed = randomBytes[0];

    CsCrc8.setOptions(polynomial, seed);

    final initialSeed = randomBytes[4] ^ seed;
    final counterSeed = connectionCounter ^ CsCrc8.compute(initialSeed);

    result[1] = polynomial;
    result[3] = seed;
    result[5] = initialSeed;
    result[7] = passwordBytes[3] ^ CsCrc8.compute(counterSeed);
    result[9] = passwordBytes[0] ^ CsCrc8.compute(result[7]);
    result[11] = passwordBytes[2] ^ CsCrc8.compute(result[9]);
    result[13] = passwordBytes[1] ^ CsCrc8.compute(result[11]);

    return result;
  }

  List<int> getPasswordBytes(int password) {
    final result = List<int>.filled(4, 0);
    result[3] = (password / 1000).toInt();
    result[2] = ((password - result[3] * 1000) / 100).toInt();
    result[1] = ((password - result[3] * 1000 - result[2] * 100) / 10).toInt();
    result[0] = password - result[3] * 1000 - result[2] * 100 - result[1] * 10;
    return result;
  }

  List<int>? changePassword(int value) {
    return _changeToPacket([
      CsBlePacketTxChange(
        key: CsValveEvb034PacketKeys.authChangePassword.value,
        valueType: CsBlePacketValueType.numberInt,
        value: value,
        minValue: 0,
        maxValue: 9999,
      ),
    ]);
  }

  List<int>? setBrineTank(int firmwareVersion, int width, int fillHeight, int remainingSaltPounds) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbBrineTankWidth.value,
      valueType: CsBlePacketValueType.numberInt,
      value: width,
      minValue: 0,
      maxValue: 30,
    ),
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbBrineTankFillHeight.value,
      valueType: CsBlePacketValueType.numberInt,
      value: fillHeight,
      minValue: 0,
      maxValue: 50,
    ),
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbBrineTankRemainingSaltPounds.value,
      valueType: CsBlePacketValueType.numberInt,
      value: remainingSaltPounds,
      minValue: 0,
      maxValue: firmwareVersion >= 611 ? 15000 : 1500,
    ),
  ]);

  List<int>? setTimeBuffer(int firmwareVersion) {
    final now = DateTime.now();

    return _changeToPacket([
      CsBlePacketTxChange(
        key: CsValveEvb034PacketKeys.dbHours.value,
        valueType: CsBlePacketValueType.numberInt,
        value:
            firmwareVersion >= 609
                ? now.hour
                : now.hour == 0
                ? 12
                : now.hour,
        minValue: firmwareVersion >= 609 ? 0 : 1,
        maxValue: firmwareVersion >= 609 ? 23 : 12,
      ),
      CsBlePacketTxChange(
        key: CsValveEvb034PacketKeys.dbMinutes.value,
        valueType: CsBlePacketValueType.numberInt,
        value: now.minute,
        minValue: 0,
        maxValue: 59,
      ),
      CsBlePacketTxChange(
        key: CsValveEvb034PacketKeys.dbSeconds.value,
        valueType: CsBlePacketValueType.numberInt,
        value: now.second,
        minValue: 0,
        maxValue: 59,
      ),
      if (firmwareVersion < 609)
        CsBlePacketTxChange(
          key: CsValveEvb034PacketKeys.dbAmPm.value,
          valueType: CsBlePacketValueType.numberInt,
          value: now.hour < 12 ? CsAmPm.am.value : CsAmPm.pm.value,
          minValue: CsAmPm.am.value,
          maxValue: CsAmPm.pm.value,
        ),
    ]);
  }

  List<int>? setWaterHardness(int value) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbWaterHardness.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value,
      minValue: 0,
      maxValue: 99,
    ),
  ]);

  List<int>? setDayOverride(int value) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbDayOverride.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value,
      minValue: 0,
      maxValue: 29,
    ),
  ]);

  List<int>? setRegenTime(int firmwareVersion, int regenHour, CsAmPm amPm) {
    int hours = regenHour;

    if (firmwareVersion >= 609) {
      hours =
          hours == 12
              ? amPm == CsAmPm.am
                  ? 0
                  : 12
              : amPm == CsAmPm.am
              ? hours
              : hours + 12;
    }

    return firmwareVersion >= 609
        ? _changeToPacket([
          CsBlePacketTxChange(
            key: CsValveEvb034PacketKeys.dbRegenTimeHours.value,
            valueType: CsBlePacketValueType.numberInt,
            value: hours,
            minValue: 0,
            maxValue: 23,
          ),
        ])
        : _changeToPacket([
          CsBlePacketTxChange(
            key: CsValveEvb034PacketKeys.dbRegenTimeHours.value,
            valueType: CsBlePacketValueType.numberInt,
            value: hours,
            minValue: 1,
            maxValue: 12,
          ),
          CsBlePacketTxChange(
            key: CsValveEvb034PacketKeys.dbRegenTimeAmPm.value,
            valueType: CsBlePacketValueType.numberInt,
            value: amPm.value,
            minValue: CsAmPm.am.value,
            maxValue: CsAmPm.pm.value,
          ),
        ]);
  }

  List<int>? setBatteryReadEnabled({required bool enabled}) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.glBatteryReadEnabled.value,
      valueType: CsBlePacketValueType.numberInt,
      value: enabled ? 1 : 0,
      minValue: 0,
      maxValue: 1,
    ),
  ]);

  List<int>? setRegenDayOverride(int value) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.asRegenDayOverride.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value,
      minValue: 0,
      maxValue: 29,
    ),
  ]);

  List<int>? setReserveCapacity(int capacity) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.asReserveCapacity.value,
      valueType: CsBlePacketValueType.numberInt,
      value: capacity,
      minValue: 0,
      maxValue: 49,
    ),
  ]);

  List<int>? setResinGrainsCapacity(int capacity) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.asTotalGrainsCapacity.value,
      valueType: CsBlePacketValueType.numberInt,
      value: capacity,
      minValue: 0,
      maxValue: 399,
    ),
  ]);

  List<int>? setDisplayState(int state) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.asDisplayOff.value,
      valueType: CsBlePacketValueType.numberInt,
      value: state,
      minValue: 0,
      maxValue: 1,
    ),
  ]);

  List<int>? setAirRechargeFrequency(int value) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.asAerationDays.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value,
      minValue: 0,
      maxValue: 9,
    ),
  ]);

  List<int>? setPulseChlorine(int value) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.asChlorinePulses.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? setPrefillEnabled({required bool value}) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbPrefillEnabled.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value ? 1 : 0,
      minValue: 0,
      maxValue: 1,
    ),
  ]);

  List<int>? setPrefillDuration(int value) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbPrefillDuration.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value,
      minValue: 1,
      maxValue: 4,
    ),
  ]);

  List<int>? setCyclePosition(CsValveEvb034Packet packet, CsValveEvb034CyclePosition position, int value) {
    final options = EnumSet(CsValveEvb034PositionOptions.values)..addAll(packet.asPositionOptions);
    final maxValue = options.contains(CsValveEvb034PositionOptions.timeIsSaltPounds) ? 99 : 199;
    final int actualValue = max(0, min(maxValue, value));

    return _changeToPacket([
      CsBlePacketTxChange(
        key: CsValveEvb034PacketKeys.asPositionTimes.value,
        valueType: CsBlePacketValueType.array,
        value: List<int>.filled(8, 0)..[position.value] = actualValue,
        minValue: 0,
        maxValue: 0,
      ),
    ]);
  }

  List<int>? resetTotalGallonsCounter() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.shGallonsTotalizerResettable.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 0,
      minValue: 0,
      maxValue: 0,
    ),
  ]);

  List<int>? resetTotalRegensCounter() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.shRegenCounterResettable.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 0,
      minValue: 0,
      maxValue: 0,
    ),
  ]);

  List<int>? setLeaseModeActive({required bool value}) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.glLeaseModeActive.value,
      valueType: CsBlePacketValueType.numberInt,
      value: value ? 1 : 0,
      minValue: 0,
      maxValue: 1,
    ),
  ]);

  List<int>? regenNow() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.glRegenNow.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 0,
      minValue: 0,
      maxValue: 0,
    ),
  ]);

  List<int>? regenLater() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.glRegenLater.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 0,
      minValue: 0,
      maxValue: 0,
    ),
  ]);

  List<int>? findHome() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.glFindHome.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 0,
      minValue: 0,
      maxValue: 0,
    ),
  ]);

  List<int>? testModeRerun() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.tmRerun.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 0,
      minValue: 0,
      maxValue: 1000000,
    ),
  ]);

  List<int>? testModeRssi(int rssi) => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.tmRssi.value,
      valueType: CsBlePacketValueType.numberInt,
      value: rssi,
      minValue: 0,
      maxValue: 100,
    ),
  ]);

  List<int>? enableLoggingButtons() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogButtons.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingDisplay() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogDisplay.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingEeprom() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogEeprom.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingEncoder() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogEncoder.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingMeter() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogMeter.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingMotor() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogMotors.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingPinTraces() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogPinTraces.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingPowerOutputs() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogPowerOutputs.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingRtc() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogRtc.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingSocFlash() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogSocFlash.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingSocTemperature() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogSocTemperature.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingTwedoSwitch() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogTwedoSwitch.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingWatchdog() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogWatchdog.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingBluetooth() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogBluetooth.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingEepromConfig() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogEepromConfig.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingEepromConfigUpdate() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogEepromConfigUpdate.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingEncoders() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogEncoders.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingEncoderScrew() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogEncoderScrew.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingEncoderWheel() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogEncoderWheel.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingFirmwareUpdate() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogFirmwareUpdate.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingMemory() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogMemory.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingMenu() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogMenu.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingPower() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogPower.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingPowerOutput() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogPowerOutput.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingSystem() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogSystem.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingTestMode() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogTestMode.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingTwedo() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogTwedo.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? enableLoggingValveRegen() => _changeToPacket([
    CsBlePacketTxChange(
      key: CsValveEvb034PacketKeys.dbgLogValveRegen.value,
      valueType: CsBlePacketValueType.numberInt,
      value: 4,
      minValue: 0,
      maxValue: 4,
    ),
  ]);

  List<int>? _changeToPacket(List<CsBlePacketTxChange> changes) {
    final json = CsBlePacketTxChange.changesToJson(changes);
    return json.isEmpty ? null : json.codeUnits;
  }
}
