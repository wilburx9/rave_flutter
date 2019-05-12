
class RaveUtils {
  static bool isEmpty(String string) {
    return string == null || string.isEmpty;
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
