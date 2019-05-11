import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/strings.dart';

class RaveUtils {
  static bool isEmpty(String string) {
    return string == null || string.isEmpty;
  }

  /// Validates that requireed values [RavePayInitializer] are not null, negative or
  /// empty
  static String validateInitializer(RavePayInitializer init) {
    String message;
    if (init.amount == null || init.amount.isNegative)
      message = Strings.cannotBeNullOrNegative('amount');
    if (isEmpty(init.publicKey)) message = Strings.cannotBeNullOrEmpty('publicKey');
    if (isEmpty(init.encryptionKey) == null)
      message = Strings.cannotBeNullOrEmpty('encryptionKey');
    if (isEmpty(init.currency) == null) message = Strings.cannotBeNullOrEmpty('currency');
    if (isEmpty(init.country) == null) message = Strings.cannotBeNullOrEmpty('country');
    if (init.narration == null) message = Strings.cannotBeNull('narration');
    if (init.fName == null) message = Strings.cannotBeNull('fName');
    if (init.lName == null) message = Strings.cannotBeNull('lName');
    if (init.subAccounts == null) message = Strings.cannotBeNull('subAccounts');
    if (init.withAch == null) message = Strings.cannotBeNull('withAch');
    if (init.withMpesa == null) message = Strings.cannotBeNull('withMpesa');
    if (init.withAccount == null) message = Strings.cannotBeNull('withAccount');
    if (init.withCard == null) message = Strings.cannotBeNull('withCard');
    if (init.withGHMobileMoney == null)
      message = Strings.cannotBeNull('withGHMobileMoney');
    if (init.withUgMobileMoney == null)
      message = Strings.cannotBeNull('withUgMobileMoney');
    if (init.isPreAuth == null) message = Strings.cannotBeNull('isPreAuth');
    if (init.displayFee == null) message = Strings.cannotBeNull('displayFee');
    return message;
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
