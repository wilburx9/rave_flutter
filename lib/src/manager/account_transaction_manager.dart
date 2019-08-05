import 'package:flutter/material.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';

class AccountTransactionManager extends BaseTransactionManager {
  AccountTransactionManager(
      {@required BuildContext context,
      @required TransactionComplete onTransactionComplete})
      : super(context: context, onTransactionComplete: onTransactionComplete);

  @override
  charge(Payload payload) {
    // TODO: implement charge
    return null;
  }

  @override
  processTransaction(Payload payload) {
    // TODO: implement processTransaction
    return null;
  }
}
