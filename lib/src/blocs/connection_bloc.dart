import 'dart:async';

import 'package:rave_flutter/src/repository/repository.dart';

class ConnectionBloc {
  static ConnectionBloc get instance => getIt<ConnectionBloc>();
  final _controller = StreamController<ConnectionState>.broadcast();

  late Stream<ConnectionState> _stream;

  Stream<ConnectionState> get stream => _stream;

  ConnectionBloc._() {
    _stream = _controller.stream;
    setState(ConnectionState.done);
  }

  factory ConnectionBloc() => ConnectionBloc._();

  setState(ConnectionState s) => _controller.add(s);

  dispose() => _controller.close();
}

enum ConnectionState { waiting, done }
