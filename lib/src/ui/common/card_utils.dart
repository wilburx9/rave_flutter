import 'package:rave_flutter/src/ui/fields/card_number_field.dart';

class CardUtils {
  static CardType getTypeForIIN(String value) {
    var input = getCleanedNumber(value);
    var number = input.trim();
    if (number.isEmpty) {
      return CardType.unknown;
    }

    if (number.startsWith(startingPatternVisa)) {
      return CardType.visa;
    } else if (number.startsWith(startingPatternMaster)) {
      return CardType.master;
    } else if (number.startsWith(startingPatternAmex)) {
      return CardType.amex;
    } else if (number.startsWith(startingPatternDiners)) {
      return CardType.diners;
    } else if (number.startsWith(startingPatternJCB)) {
      return CardType.jcb;
    } else if (number.startsWith(startingPatternVerve)) {
      return CardType.verve;
    } else if (number.startsWith(startingPatternDiscover)) {
      return CardType.discover;
    }
    return CardType.unknown;
  }

  /// Convert the two-digit year to four-digit year if necessary
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static String getCleanedNumber(String text) {
    if (text == null) {
      return '';
    }
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static String getCardIcon(CardType type) {
    String img = "";
    switch (type) {
      case CardType.master:
        img = 'mastercard';
        break;
      case CardType.visa:
        img = 'visa';
        break;
      case CardType.verve:
        img = 'verve';
        break;
      case CardType.amex:
        img = 'amex';
        break;
      case CardType.discover:
        img = 'discover.png';
        break;
      case CardType.diners:
        img = 'diners.png';
        break;
      case CardType.jcb:
        img = 'jcb';
        break;
      case CardType.unknown:
        img = 'generic_card';
        break;
    }
    return img;
  }

  static List<String> getExpiryDate(String value) {
    var split = value.split(new RegExp(r'(\/)'));
    return [split[0], split[1]];
  }
}

final startingPatternVisa = RegExp(r'[4]');
final startingPatternMaster = RegExp(
    r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))');
final startingPatternAmex = RegExp(r'((34)|(37))');
final startingPatternDiners = RegExp(r'((30[0-5])|(3[89])|(36)|(3095))');
final startingPatternJCB = RegExp(r'(352[89]|35[3-8][0-9])');
final startingPatternVerve = RegExp(r'((506(0|1))|(507(8|9))|(6500))');
final startingPatternDiscover = RegExp(r'((6[45])|(6011))');
