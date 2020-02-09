import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/ui/common/card_utils.dart';

class ValidatorUtils {
  static bool isCVVValid(String value) {
    if (value == null || value.trim().isEmpty) return false;

    var cvcValue = value.trim();
    bool validLength = cvcValue.length >= 3 && cvcValue.length <= 4;
    return !(!isWholeNumberPositive(cvcValue) || !validLength);
  }

  static bool isCardNumberValid(String value) {
    if (value == null || value.trim().isEmpty) return false;

    var number = CardUtils.getCleanedNumber(value.trim());

    //check if formattedNumber is empty or card isn't a whole positive number or isn't Luhn-valid
    return isWholeNumberPositive(number) && _isValidLuhnNumber(number);
  }

  static bool isAmountValid(String value) {
    if (value == null || value.trim().isEmpty) return false;
    double number = double.tryParse(value.trim());
    return number != null && !number.isNegative && number > 0;
  }

  static bool isPhoneValid(String value) {
    if (value == null || value.trim().isEmpty) return false;

    // We are assuming no phone number is less than 3 characters
    return value.trim().length > 3;
  }

  static bool isAccountValid(String value) {
    if (value == null || value.trim().isEmpty) return false;
    return value.trim().length == 10;
  }

  static bool isBVNValid(String value) {
    if (value == null || value.trim().isEmpty) return false;
    return value.trim().length == 11;
  }

  static bool isEmailValid(String value) {
    if (value == null || value.trim().isEmpty) return false;
    String p =
        '[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})';

    return RegExp(p).hasMatch(value);
  }

  static bool isWholeNumberPositive(String value) {
    if (value == null) {
      return false;
    }

    for (var i = 0; i < value.length; ++i) {
      if (!((value.codeUnitAt(i) ^ 0x30) <= 9)) {
        return false;
      }
    }

    return true;
  }

  static bool isUrlValid(String url) {
    final source =
        r'^(https?|ftp|file|http)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]';
    return RegExp(source).hasMatch(url);
  }

  /// Checks if the card has expired.
  /// Returns true if the card has expired; false otherwise
  static bool validExpiryDate(int expiryMonth, int expiryYear) {
    return !(expiryMonth == null || expiryYear == null) &&
        isNotExpired(expiryYear, expiryMonth);
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        CardUtils.convertYearTo4Digits(year) == now.year &&
            (month < now.month + 1);
  }

  static bool isValidMonth(int month) {
    return (month > 0) && (month < 13);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = CardUtils.convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the current year is more than card's year
    return fourDigitsYear < now.year;
  }

  static bool isNotExpired(int year, int month) {
    if (month > 12 || year > 2999) {
      return false;
    }
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  /// Validates the number against Luhn algorithm (https://en.wikipedia.org/wiki/Luhn_algorithm)
  ///
  /// [number]  - number to validate
  /// Returns true if the number is passes the verification.
  static bool _isValidLuhnNumber(String number) {
    int sum = 0;
    int length = number.trim().length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      var source = number[length - i - 1];

      // Check if character is digit before parsing it
      if (!((number.codeUnitAt(i) ^ 0x30) <= 9)) {
        return false;
      }
      int digit = int.parse(source);

      // if it's odd, multiply by 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    return sum % 10 == 0;
  }

  /// Validates that required the variables of [RavePayInitializer]
  /// are not null, negative or  empty
  static String validateInitializer(RavePayInitializer init) {
    if (isEmpty(init.publicKey))
      return Strings.cannotBeNullOrEmpty('publicKey');
    if (isEmpty(init.encryptionKey) == null)
      return Strings.cannotBeNullOrEmpty('encryptionKey');
    if (isEmpty(init.txRef)) {
      return Strings.cannotBeNullOrEmpty("txRef");
    }
    if (isEmpty(init.currency) == null)
      return Strings.cannotBeNullOrEmpty('currency');
    if (isEmpty(init.country) == null)
      return Strings.cannotBeNullOrEmpty('country');
    if (init.narration == null) return Strings.cannotBeNull('narration');
    if (init.redirectUrl == null) return Strings.cannotBeNull('redirectUrl');
    if (init.fName == null) return Strings.cannotBeNull('fName');
    if (init.lName == null) return Strings.cannotBeNull('lName');
    if (init.acceptAchPayments == null) return Strings.cannotBeNull('withAch');
    if (init.acceptMpesaPayments == null)
      return Strings.cannotBeNull('withMpesa');
    if (init.acceptAccountPayments == null)
      return Strings.cannotBeNull('withAccount');
    if (init.acceptCardPayments == null)
      return Strings.cannotBeNull('withCard');
    if (init.acceptGHMobileMoneyPayments == null)
      return Strings.cannotBeNull('withGHMobileMoney');
    if (init.acceptUgMobileMoneyPayments == null)
      return Strings.cannotBeNull('withUgMobileMoney');
    if (init.isPreAuth == null) return Strings.cannotBeNull('isPreAuth');
    if (init.displayFee == null) return Strings.cannotBeNull('displayFee');
    if (init.displayEmail == null) return Strings.cannotBeNull("displayEmail");
    if (init.displayAmount == null)
      return Strings.cannotBeNull("displayAmount");
    if (!init.acceptCardPayments &&
        !init.acceptAccountPayments &&
        !init.acceptMpesaPayments &&
        !init.acceptGHMobileMoneyPayments &&
        !init.acceptUgMobileMoneyPayments) {
      return "No payment mode";
    }
    return null;
  }
}
