import 'dart:async';

import 'package:rave_flutter/src/rave_result.dart';
import 'package:rave_flutter/src/repository/repository.dart';

class ResultBloc {
  static ResultBloc get instance => getIt<ResultBloc>();
  final _controller = StreamController<RaveResult>.broadcast();

  Stream<RaveResult> _stream;

  Stream<RaveResult> get stream => _stream;

  ResultBloc._() {
    _stream = _controller.stream;
  }

  factory ResultBloc() => ResultBloc._();

  setState(RaveResult r) => _controller.add(r);

  dispose() => _controller.close();
}

