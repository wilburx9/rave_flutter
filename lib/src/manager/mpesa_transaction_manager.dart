import 'dart:async';

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';
import 'package:rave_flutter/src/models/requery_model.dart';

class MpesaTransactionManager extends BaseTransactionManager {
  MpesaTransactionManager(
      {required BuildContext context,
      required TransactionComplete onTransactionComplete})
      : super(
          context: context,
          onTransactionComplete: onTransactionComplete,
        );

  @override
  charge() async {
    setConnectionState(ConnectionState.waiting);
    try {
      final response = await service!.charge(
        ChargeRequestBody.fromPayload(
          payload: payload!
            ..isMpesa = true
            ..isMpesaLipa = true,
          type: "mpesa",
        ),
      );

      setConnectionState(ConnectionState.done);

      flwRef = response.flwRef;

      if (!response.hasData) {
        handleError(e: RaveException(data: Strings.noResponseData));
        return;
      }

      reQueryTransaction(onComplete: _handleReQuery);

      return;
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }

  _handleReQuery(ReQueryResponseModel response) {
    if (!response.hasData!) {
      handleError(e: RaveException(data: Strings.noResponseData));
      return;
    }

    var responseCode = response.chargeResponseCode?.toUpperCase();

    if (responseCode == "02") {
      // Throttle for 3000 milliseconds
      Timer(Duration(seconds: 3), () {
        reQueryTransaction(onComplete: _handleReQuery);
      });
      return;
    }

    if (responseCode == "00") {
      onComplete(response);
      return;
    }

    handleError(
      e: RaveException(data: response.status),
      rawResponse: response.rawResponse,
    );
  }
}
