import 'dart:async';

import 'package:rave_flutter/src/repository/repository.dart';

class ConnectionBloc {
  static ConnectionBloc get instance => getIt<ConnectionBloc>();
  final _controller = StreamController<DataState>.broadcast();

  Stream<DataState> _stream;

  Stream<DataState> get stream => _stream;

  ConnectionBloc._() {
    _stream = _controller.stream;
    setState(DataState.done);
  }

  factory ConnectionBloc() => ConnectionBloc._();

  setState(DataState s) => _controller.add(s);

  dispose() => _controller.close();
}

enum DataState { waiting, done }
