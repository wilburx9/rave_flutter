import 'package:flutter/material.dart' hide ConnectionState;
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';

class AccountTransactionManager extends BaseTransactionManager {
  AccountTransactionManager(
      {@required BuildContext context,
      @required TransactionComplete onTransactionComplete})
      : super(context: context, onTransactionComplete: onTransactionComplete);

  @override
  charge() async {
    setConnectionState(ConnectionState.waiting);
    try {
      var response =
          await service.charge(ChargeRequestBody.fromPayload(payload));

      setConnectionState(ConnectionState.done);
    } on RaveException catch (e) {
      handleError(e);
    }
  }
}
