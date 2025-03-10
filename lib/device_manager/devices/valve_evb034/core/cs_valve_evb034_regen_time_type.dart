enum CsValveEvb034RegenTimeType {
  seconds(0),
  minutes(1),
  saltPounds(2);

  const CsValveEvb034RegenTimeType(this.value);
  final int value;

  static CsValveEvb034RegenTimeType fromInt(int value) {
    return CsValveEvb034RegenTimeType.values.firstWhere((e) => e.value == value, orElse: () => seconds);
  }
}
