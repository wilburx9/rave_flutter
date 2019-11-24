import 'package:rave_flutter/src/common/strings.dart';

class RaveException {
  final String message;

  RaveException({data}) : message = _getMessage(data);

  static String _getMessage(e) {
    if (e == null) return Strings.sthWentWrong;

    if (e is String) {
      return e;
    }
    if (e is Map) {
      if (e.containsKey("message")) {
        return e["message"];
      }
      if (e.containsKey("data")) {
        var data = e["data"];
        if (data is Map) {
          return data["message"];
        } else {
          return data;
        }
      }
    }

    return Strings.sthWentWrong;
  }
}
