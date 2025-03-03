enum CsDeviceSaltSensorStatus {
  unknown(-1),
  saltOkay(0),
  saltLow(1);

  const CsDeviceSaltSensorStatus(this.value);
  final int value;

  static CsDeviceSaltSensorStatus fromInt(int value) {
    return CsDeviceSaltSensorStatus.values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }
}
