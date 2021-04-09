import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rave_flutter/src/repository/repository.dart';

class TransactionBloc {
  static TransactionBloc get instance => getIt<TransactionBloc>();
  final _controller = StreamController<TransactionState>.broadcast();

  late Stream<TransactionState> _stream;

  Stream<TransactionState>? get stream => _stream;

  TransactionBloc._() {
    _stream = _controller.stream;
    setState(TransactionState._defaults());
  }

  factory TransactionBloc() => TransactionBloc._();

  setState(TransactionState s) => _controller.add(s);

  dispose() => _controller.close();
}

class TransactionState {
  final State state;
  final ValueChanged<dynamic>? callback;
  final data;

  TransactionState({required this.state, this.callback, this.data});

  TransactionState._defaults()
      : this.state = State.initial,
        this.data = null,
        this.callback = null;
}

enum State { initial, pin, otp, avsSecure }
