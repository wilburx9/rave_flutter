import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:tripledes/tripledes.dart';

class RaveUtils {
  static bool isEmpty(String string) {
    return string == null || string.isEmpty;
  }

  static String formatAmount(num amount) {
    return new NumberFormat.currency(name: '').format(amount);
  }

  static String getEncryptedData(String str, String key) {
    print("Encrypting: $str");
    var blockCipher = BlockCipher(TripleDESEngine(), key);
    return blockCipher.encodeB64(str);
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

putIfNotNull({@required Map map, @required key, @required value}) {
  if (value == null || (value is String && value.isEmpty)) {
    return;
  }

  map[key] = value;
}
