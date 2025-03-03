enum CsValveEvb034Type {
  ///
  /// Unknown Valve
  ///
  unknown(0),

  ///
  /// Metered Softener, *Standard Piston*
  ///
  valveType01(1),

  ///
  /// Timeclock Softener, *Standard Piston*
  ///
  valveType02(2),

  ///
  /// Metered Softener, *Shutoff Piston*
  ///
  valveType03(3),

  ///
  /// Backwashing Filter, *Standard Piston*
  ///
  valveType04(4),

  ///
  /// Backwashing Filter, *Shutoff Piston*
  ///
  valveType05(5),

  ///
  /// HydroxR Filter, *Standard Piston*
  ///
  valveType06(6),

  ///
  /// ReactR Filter, *Standard Piston*
  ///
  valveType07(7),

  ///
  /// Ultra Filter, *Standard Piston*
  ///
  valveType08(8),

  ///
  /// Aeration Filter, *Standard Piston*
  ///
  valveType09(9),

  ///
  /// Aeration Filter, *Final Rinse Piston*
  ///
  valveType10(10),

  ///
  /// Not Used
  ///
  valveType11(11),

  ///
  /// Not Used
  ///
  valveType12(12),

  ///
  /// Aeration Pro Filter, *Standard Piston*
  ///
  valveType13(13),

  ///
  /// Aeration Pro Filter, *Final Rinse Piston*
  ///
  valveType14(14),

  ///
  /// Not Used
  ///
  valveType15(15),

  ///
  /// Aeration Pro Filter (for Signature 3), *Final Rinse Piston*
  ///
  valveType16(16),

  ///
  /// Commercial Metered Softener, *Shutoff Piston*
  ///
  valveType17(17),

  ///
  /// Commercial Backwashing Filter, *Shutoff Piston*
  ///
  valveType18(18),

  ///
  /// SD-1 Metered Softener, *Standard Piston*
  ///
  valveType19(19),

  ///
  /// SD-1 Backwashing Filter, *Standard Piston*
  ///
  valveType20(20),

  ///
  /// SD-1 Metered Softener, *Shutoff Piston*
  ///
  valveType21(21),

  ///
  /// SD-1 Backwashing Filter, *Shutoff Piston*
  ///
  valveType22(22),

  ///
  /// SD-1 Aeration Filter, *Shutoff Piston*
  ///
  valveType23(23),

  ///
  /// SD-1 Aeration Pro Filter, *Shutoff Piston*
  ///
  valveType24(24),

  ///
  /// Commercial Aeration Filter, *Shutoff Piston*
  ///
  valveType25(25),

  ///
  /// Backwashing Filter With Feed Pump, *Standard Piston*
  ///
  valveType26(26),

  ///
  /// Backwashing Filter With Feed Pump, *Final Rinse Piston*
  ///
  valveType27(27),

  ///
  /// Commercial Test Valve
  ///
  valveType254(254),

  ///
  /// Test Valve
  ///
  testValve(255);

  const CsValveEvb034Type(this.value);
  final int value;

  static CsValveEvb034Type fromInt(int value) {
    return CsValveEvb034Type.values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }
}
