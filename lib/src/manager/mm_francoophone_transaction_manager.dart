
import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';

class MMFrancophoneTransactionManager extends BaseTransactionManager {
  MMFrancophoneTransactionManager(
      {@required BuildContext context,
      @required TransactionComplete onTransactionComplete})
      : super(
          context: context,
          onTransactionComplete: onTransactionComplete,
        );

  @override
  charge() async {
    setConnectionState(ConnectionState.waiting);
    try {
      var response = await service.charge(
        ChargeRequestBody.fromPayload(
            payload: payload..isMobileMoneyFranco = true
            , type: "mobilemoneyfranco"),
      );
      setConnectionState(ConnectionState.done);

      flwRef = response.flwRef;

      if (!response.hasData) {
        handleError(e: RaveException(data: Strings.noResponseData));
        return;
      }

      if (response.status != "success") {
        handleError(e: RaveException(data: Strings.sthWentWrong));
        return;
      }

    } on RaveException catch (e) {
      handleError(e: e);
    }
  }
}
