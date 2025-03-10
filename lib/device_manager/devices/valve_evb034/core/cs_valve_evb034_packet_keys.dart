
enum CsValveEvb034PacketKeys {
  unknown(''),

  // Auth Keys
  authState('as'),
  authChangePassword('acp'),

  // Device List Keys
  dlSerialNumberA('dlsa'),
  dlSerialNumberB('dlsb'),
  dlFirmwareVersion('dlf'),
  dlRegenMotorInProgress('dlr'),
  dlIsTwinValve('dli'),
  dlIsClackValve('dlic'),
  dlValveType('dlvt'),
  dlValveSeries('dlvs'),
  dlConnectionCounter('dlc'),

  // Dashboard Keys,
  dbHours('dh'),
  dbMinutes('dm'),
  dbSeconds('ds'),
  dbAmPm('da'),
  dbBatteryLevel('dbl'),
  dbTotalGallonsRemaining('dtgr'),
  dbPeakFlowDaily('dpfd'),
  dbWaterHardness('dwh'),
  dbDayOverride('ddo'),
  dbWaterUsedToday('dwu'),
  dbAvgWaterUsed('dwau'),
  dbCurrentDayOverride('dcdo'),
  dbRegenTimeHours('drth'),
  dbRegenTimeMinutes('drtm'),
  dbRegenTimeAmPm('drta'),
  dbRegenTimeRemaining('drtr'),
  dbRegenTimeType('drtt'),
  dbRegenCurrentPosition('drcp'),
  dbRegenInAeration('dria'),
  dbRegenSoakTimer('drst'),
  dbPrefillEnabled('dpe'),
  dbPrefillDuration('dpd'),
  dbPrefillSoakMode('dps'),
  dbBrineTankWidth('dbtw'),
  dbBrineTankFillHeight('dbth'),
  dbBrineTankRefillTime('dbrt'),
  dbBrineTankTotalSaltPounds('dbts'),
  dbBrineTankRemainingSaltPounds('dbtr'),

  // Advanced Settings Keys
  asDaysUntilRegen('asd'),
  asRegenDayOverride('asr'),
  asReserveCapacity('asrc'),
  asTotalGrainsCapacity('astg'),
  asAerationDays('asad'),
  asChlorinePulses('ascp'),
  asDisplayOff('asdo'),
  asNumPositions('asnp'),
  asPositionTimes('aspt'),
  asPositionOptions('aspo'),

  // Status & History Keys
  shRegenCounter('shrc'),
  shRegenCounterResettable('shrr'),
  shGallonsTotalizer('shgt'),
  shGallonsTotalizerResettable('shgr'),

  // Dealer Information Keys
  diName('din'),
  diPhone('dip'),
  diAddress1('dia1'),
  diAddress2('dia2'),
  diEmail('die'),
  diWeb('diw'),

  // Graph Keys
  grPeakFlowDaily('grp'),
  grGallonsUsedDaily('ggd'),
  grGallonsUsedBetweenRegens('ggr'),

  // Global Keys
  glValveStatus('gvs'),
  glPresentFlow('gpf'),
  glLeaseModeEnabled('glme'),
  glLeaseModeActive('glma'),
  glRegenActive('gra'),
  glRegenState('grs'),
  glRegenNow('grn'),
  glRegenLater('grl'),
  glBatteryReadEnabled('gbre'),
  glFindHome('gfh'),

  // Test Mode Keys
  tmRerun('tmr'),
  tmRssi('tmrs'),
  tmCounter('tmc'),
  tmRunning('tmru'),
  tmStatusBits('tmts'),
  tmErrorBits('tmte'),

  // Debug Logging Keys
  dbgLogAdc('dlad'),
  dbgLogButtons('dlbu'),
  dbgLogDisplay('dldi'),
  dbgLogEeprom('dlee'),
  dbgLogEncoder('dle'),
  dbgLogMeter('dlme'),
  dbgLogMotors('dlmt'),
  dbgLogPinTraces('dlpt'),
  dbgLogPowerOutputs('dlps'),
  dbgLogRtc('dlrt'),
  dbgLogSocFlash('dlsf'),
  dbgLogSocTemperature('dlst'),
  dbgLogTwedoSwitch('dlts'),
  dbgLogWatchdog('dlwd'),
  dbgLogBluetooth('dlbt'),
  dbgLogEepromConfig('dlec'),
  dbgLogEepromConfigUpdate('dleu'),
  dbgLogEncoders('dlen'),
  dbgLogEncoderScrew('dles'),
  dbgLogEncoderWheel('dlew'),
  dbgLogFirmwareUpdate('dlfu'),
  dbgLogMemory('dlm'),
  dbgLogMenu('dlmu'),
  dbgLogPower('dlp'),
  dbgLogPowerOutput('dlpo'),
  dbgLogSystem('dls'),
  dbgLogTestMode('dltm'),
  dbgLogTwedo('dlt'),
  dbgLogValveRegen('dlvr');

  const CsValveEvb034PacketKeys(this.value);
  final String value;

  int compareTo(CsValveEvb034PacketKeys other) => value.compareTo(other.value);
  bool operator >(CsValveEvb034PacketKeys other) => value.compareTo(other.value) > 0;
  bool operator <(CsValveEvb034PacketKeys other) => value.compareTo(other.value) < 0;
  bool operator >=(CsValveEvb034PacketKeys other) => value.compareTo(other.value) >= 0;
  bool operator <=(CsValveEvb034PacketKeys other) => value.compareTo(other.value) <= 0;
}
