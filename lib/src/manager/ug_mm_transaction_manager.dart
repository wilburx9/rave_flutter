import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:rave_flutter/rave_flutter.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';

class UgMMTransactionManager extends BaseTransactionManager {
  UgMMTransactionManager(
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
      final response = await service.charge(
        ChargeRequestBody.fromPayload(
          payload: payload..isMobileMoneyUg = true,
          type: "mobilemoneyuganda",
        ),
      );

      setConnectionState(ConnectionState.done);

      flwRef = response.flwRef;

      if (!response.hasData) {
        handleError(e: RaveException(data: Strings.noResponseData));
        return;
      }

      var responseStatus = response.rawResponse["status"];

      if (responseStatus == "success") {
        // Validate
        // {"status":"success","message":"Momo initiated","data":{"code":"02","status":"pending","ts":XXXXXXX,"link":"https://ravemodal-dev.herokuapp.com/captcha/verify/XXXX:XXXXXXXXXXXXX"}}
        if (response.rawResponse.containsKey("data") &&
            (response.rawResponse["data"] as Map).containsKey("link")) {
          // Load web page to complete payment
          String authUrl = (response.rawResponse["data"] as Map)["link"];
          showWebAuthorization(authUrl, reQuery: false,
              onAuthComplete: (Map resp) {
            onTransactionComplete(
                RaveResult(status: RaveStatus.success, rawResponse: resp,message:"MoMo UG Payment Complete"));
          });
        }
        return;
      }

      return;
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }
}
