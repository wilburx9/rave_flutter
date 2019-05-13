import 'package:intl/intl.dart';

class RaveUtils {
  static bool isEmpty(String string) {
    return string == null || string.isEmpty;
  }

  static String formatAmount(num amount) {
    return new NumberFormat.currency(name: '').format(amount);
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
