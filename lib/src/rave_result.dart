import 'package:meta/meta.dart';

class RaveResult {
  final RaveStatus status;
  final Map rawResponse;

  RaveResult({@required this.status, this.rawResponse});
}


enum RaveStatus{success, error, cancelled}