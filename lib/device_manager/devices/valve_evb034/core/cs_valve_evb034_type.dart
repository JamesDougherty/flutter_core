enum CsValveEvb034Type {
  unknown(-1),

  ///
  /// Valve Type 1, 3, 19 or 21
  ///
  meteredSoftener(0),

  ///
  /// Valve Type 2
  ///
  timeClockSoftener(1),

  ///
  /// Valve Type 4, 5, 6, 7, 20, 22, 26, or 27
  ///
  backwashingFilter(2),

  ///
  /// Valve Type 8
  ///
  ultraFilter(3),

  ///
  /// Valve Types 9 or 11
  ///
  centurionNitro(4),

  ///
  /// Valve Type 10 or 12
  ///
  centurionNitroSidekick(5),

  ///
  /// Valve Type 16
  ///
  centurionNitroSidekickV3(6),

  ///
  /// Valve Type 13
  ///
  nitroPro(7),

  ///
  /// Valve Type 14 or 15
  ///
  nitroProSidekick(8),

  ///
  /// Valve Type 17
  ///
  commercialMeteredSoftener(9),

  ///
  /// Valve Type 18
  ///
  commercialBackwashingFilter(10),

  ///
  /// Valve Type 23
  ///
  nitroFilter(11),

  ///
  /// Valve Type 24
  ///
  sidekick(12),

  ///
  /// Valve Type 25
  ///
  commercialAeration(13);

  const CsValveEvb034Type(this.value);
  final int value;

  static CsValveEvb034Type fromValveType(int value) {
    switch (value) {
      case 1:
      case 3:
      case 19:
      case 21:
        return meteredSoftener;

      case 2:
        return timeClockSoftener;

      case 4:
      case 5:
      case 6:
      case 7:
      case 20:
      case 22:
      case 26:
      case 27:
        return backwashingFilter;

      case 8:
        return ultraFilter;

      case 9:
      case 11:
        return centurionNitro;

      case 10:
      case 12:
        return centurionNitroSidekick;

      case 13:
        return nitroPro;

      case 14:
      case 15:
        return nitroProSidekick;

      case 16:
        return centurionNitroSidekickV3;

      case 17:
        return commercialMeteredSoftener;

      case 18:
        return commercialBackwashingFilter;

      case 23:
        return nitroFilter;

      case 24:
        return sidekick;

      case 25:
        return commercialAeration;

      default:
        return unknown;
    }
  }

  static bool isCommercial(CsValveEvb034Type valveType, {required bool isTwinValve}) =>
      !isTwinValve &&
      (valveType == commercialMeteredSoftener ||
          valveType == commercialBackwashingFilter ||
          valveType == commercialAeration);

  static bool isMeteredSoftener(CsValveEvb034Type valveType, {required bool isTwinValve}) =>
      isTwinValve ||
      valveType == meteredSoftener ||
      valveType == commercialMeteredSoftener;

  static bool isAerationValve(CsValveEvb034Type valveType, {required bool isTwinValve}) =>
      !isTwinValve &&
      valveType != commercialMeteredSoftener &&
      valveType != commercialBackwashingFilter &&
      valveType != meteredSoftener &&
      valveType != timeClockSoftener &&
      valveType != backwashingFilter &&
      valveType != ultraFilter;
}
