enum CsAmPm {
  am(0),
  pm(1);

  const CsAmPm(this.value);
  final int value;

  static CsAmPm fromInt(int value) {
    return CsAmPm.values.firstWhere((e) => e.value == value, orElse: () => am);
  }
}
