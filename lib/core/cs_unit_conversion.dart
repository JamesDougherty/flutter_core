
import 'cs_unit_conversion_type.dart';
import 'cs_utilities.dart';

class CsUnitConversion {
  static double gpgToMgl(double value) => value * 17.12;
  static double mglToGpg(double value) => value * 0.05841;
  static double gallonsToLiters(double value) => value * 3.78541;
  static double litersToGallons(double value) => value * 0.2641720524;
  static double grainsToGrams(double value) => value / 15.432;
  static double gramsToGrains(double value) => value * 15.432;
  static double poundsToKilograms(double value) => value * 0.454;
  static double kilogramsToPounds(double value) => value / 0.454;

  ///
  /// This function will convert a standard measurement value to the corresponding metric measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either GPG, GPM, Gallons, Grains.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The standard measurement value converted to the corresponding metric measurement value.
  ///
  static int convertToMetricInt(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.gpg:
        return gpgToMgl(value).round();

      case CsUnitConversionType.gpm:
      case CsUnitConversionType.gallons:
        return gallonsToLiters(value).round();

      case CsUnitConversionType.grains:
        return grainsToGrams(value).round();

      case CsUnitConversionType.pounds:
        return poundsToKilograms(value).round();

      default:
        return value.round();
    }
  }

  ///
  /// This function will convert a standard measurement value to the corresponding metric measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either GPG, GPM, Gallons, Grains.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The standard measurement value converted to the corresponding metric measurement value.
  ///
  static double convertToMetric(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.gpg:
        return gpgToMgl(value);

      case CsUnitConversionType.gpm:
      case CsUnitConversionType.gallons:
        return gallonsToLiters(value);

      case CsUnitConversionType.grains:
        return grainsToGrams(value);

      case CsUnitConversionType.pounds:
        return poundsToKilograms(value);

      default:
        return value;
    }
  }

  ///
  /// This function will convert a standard measurement value to the corresponding metric measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either GPG, GPM, Gallons, Grains.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The standard measurement value converted to the corresponding metric measurement value.
  ///
  static String convertToMetricString(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.gpg:
        return gpgToMgl(value).toStringAsFixed(2);

      case CsUnitConversionType.gpm:
      case CsUnitConversionType.gallons:
        return gallonsToLiters(value).toStringAsFixed(2);

      case CsUnitConversionType.grains:
        return grainsToGrams(value).toStringAsFixed(2);

      case CsUnitConversionType.pounds:
        return poundsToKilograms(value).toStringAsFixed(2);

      default:
        return value.toStringAsFixed(2);
    }
  }

  ///
  /// This function will convert a standard measurement value to the corresponding metric measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either GPG, GPM, Gallons, Grains.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The standard measurement value converted to the corresponding metric measurement value.
  ///
  static String convertToMetricStringInt(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.gpg:
        return CsUtilities.addCommasToNumber(gpgToMgl(value).round());

      case CsUnitConversionType.gpm:
      case CsUnitConversionType.gallons:
        return CsUtilities.addCommasToNumber(gallonsToLiters(value).round());

      case CsUnitConversionType.grains:
        return CsUtilities.addCommasToNumber(grainsToGrams(value).round());

      case CsUnitConversionType.pounds:
        return CsUtilities.addCommasToNumber(poundsToKilograms(value).round());

      default:
        return CsUtilities.addCommasToNumber(value.round());
    }
  }

  ///
  /// This function will convert a metric measurement value to the corresponding standard measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either MgL, LPM, Liters or Grams.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The metric measurement value converted to the corresponding standard measurement value.
  ///
  static int convertFromMetricInt(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.mgl:
        return mglToGpg(value).round();

      case CsUnitConversionType.lpm:
      case CsUnitConversionType.liters:
        return litersToGallons(value).round();

      case CsUnitConversionType.grams:
        return gramsToGrains(value).round();

      case CsUnitConversionType.kilograms:
        return kilogramsToPounds(value).round();

      default:
        return value.round();
    }
  }

  ///
  /// This function will convert a metric measurement value to the corresponding standard measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either MgL, LPM, Liters or Grams.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The metric measurement value converted to the corresponding standard measurement value.
  ///
  static double convertFromMetric(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.mgl:
        return mglToGpg(value);

      case CsUnitConversionType.lpm:
      case CsUnitConversionType.liters:
        return litersToGallons(value);

      case CsUnitConversionType.grams:
        return gramsToGrains(value);

      case CsUnitConversionType.kilograms:
        return kilogramsToPounds(value);

      default:
        return value;
    }
  }

  ///
  /// This function will convert a metric measurement value to the corresponding standard measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either MgL, LPM, Liters or Grams.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The metric measurement value converted to the corresponding standard measurement value.
  ///
  static String convertFromMetricString(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.mgl:
        return mglToGpg(value).toStringAsFixed(2);

      case CsUnitConversionType.lpm:
      case CsUnitConversionType.liters:
        return litersToGallons(value).toStringAsFixed(2);

      case CsUnitConversionType.grams:
        return gramsToGrains(value).toStringAsFixed(2);

      case CsUnitConversionType.kilograms:
        return kilogramsToPounds(value).toStringAsFixed(2);

      default:
        return value.toStringAsFixed(2);
    }
  }

  ///
  /// This function will convert a metric measurement value to the corresponding standard measurement value. If the
  /// wrong unit is passed then the value will be returned untouched.
  ///
  /// **Parameters**
  /// - `unit` The *source* unit. ***This must be either MgL, LPM, Liters or Grams.***
  /// - `value` The value that should be converted.
  ///
  /// **Returns**
  /// The metric measurement value converted to the corresponding standard measurement value.
  ///
  static String convertFromMetricStringInt(CsUnitConversionType unit, double value) {
    switch (unit) {
      case CsUnitConversionType.mgl:
        return CsUtilities.addCommasToNumber(mglToGpg(value).round());

      case CsUnitConversionType.lpm:
      case CsUnitConversionType.liters:
        return CsUtilities.addCommasToNumber(litersToGallons(value).round());

      case CsUnitConversionType.grams:
        return CsUtilities.addCommasToNumber(gramsToGrains(value).round());

      case CsUnitConversionType.kilograms:
        return CsUtilities.addCommasToNumber(kilogramsToPounds(value).round());

      default:
        return CsUtilities.addCommasToNumber(value.round());
    }
  }
}
