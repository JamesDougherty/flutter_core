
import '../branding/core/shared/cs_branding_core_strings_shared.dart';

enum CsBrineTank {
  unknown(0),
  tank16X33(16),
  tank18X40(18),
  tank24X50(24),
  tank30X50(30);

  @override
  String toString() =>
    switch (value) {
      16 => CsBrandingCoreStringsShared.brineTank16x33,
      18 => CsBrandingCoreStringsShared.brineTank18x40,
      24 => CsBrandingCoreStringsShared.brineTank24x50,
      30 => CsBrandingCoreStringsShared.brineTank30x50,
      _ => CsBrandingCoreStringsShared.unknown,
    };

  const CsBrineTank(this.value);
  final int value;

  static CsBrineTank fromInt(int value) {
    return CsBrineTank.values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }

  static List<int> getWidths() {
    final widths = <int>[];

    for (final entry in values) {
      if (entry != unknown) {
        widths.add(entry.value);
      }
    }

    return widths;
  }

  static int getMaxHeight(CsBrineTank value) =>
    switch (value) {
      tank16X33 => 33,
      tank18X40 => 40,
      _ => 50,
    };

  static CsBrineTank getDefaultWidth({required bool isCommercial}) =>
    !isCommercial ? tank16X33 : tank18X40;

  static int getDefaultHeight({required bool isCommercial}) =>
    !isCommercial ? 33 : 40;

  static int getDefaultSaltHeight({required bool isCommercial}) =>
    !isCommercial ? 24 : 31;

  static double getFillRate({required bool isCommercial}) =>
    !isCommercial ? 0.5 : 3.0;

  static double getAbsorbedSaltPerMinute({required bool isCommercial}) =>
    3.0 /* Absorbed Salt Per Gallon */ *
    getFillRate(isCommercial: isCommercial);

  static double getAbsorbedSaltPerRegen({required bool isCommercial, required int refillTime}) =>
    isCommercial ? refillTime.toDouble() : refillTime * getAbsorbedSaltPerMinute(isCommercial: false);

  static double getTotalSaltPounds(CsBrineTank value, int fillHeight) =>
    switch (value) {
      tank18X40 => fillHeight * 10.4,
      tank24X50 => fillHeight * 18.6,
      tank30X50 => fillHeight * 29.55,
      _ => fillHeight * 8.1,
    };
}
