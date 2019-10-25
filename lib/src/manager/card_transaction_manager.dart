import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/rave_constants.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';

class CardTransactionManager extends BaseTransactionManager {
  CardTransactionManager(
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
      var response =
          await service.charge(ChargeRequestBody.fromPayload(payload: payload));

      setConnectionState(ConnectionState.done);

      flwRef = response.flwRef;

      var suggestedAuth = response.suggestedAuth?.toUpperCase();
      var authModelUsed = response.authModelUsed?.toUpperCase();
      var message = response.message.toUpperCase();
      var chargeResponseCode = response.chargeResponseCode;

      if (message == RaveConstants.AUTH_SUGGESTION) {
        if (suggestedAuth == RaveConstants.PIN) {
          _onPinRequested();
          return;
        }

        if (suggestedAuth == RaveConstants.AVS_VBVSECURECODE ||
            suggestedAuth == RaveConstants.NO_AUTH_INTERNATIONAL) {
          _onBillingRequest();
          return;
        }
      }

      if (message == RaveConstants.V_COMP) {
        if (chargeResponseCode == "02") {
          print("Suggested Auth = $suggestedAuth");
          if (authModelUsed == RaveConstants.ACCESS_OTP) {
            onOtpRequested(response.chargeResponseMessage);
            return;
          }

          if (authModelUsed == RaveConstants.PIN) {
            _onPinRequested();
            return;
          }

          if (authModelUsed == RaveConstants.VBV) {
            showWebAuthorization(response.authUrl);
            return;
          }
        }

        if (chargeResponseCode == "00") {
          _onNoAuthUsed();
          return;
        }
      }

      if (authModelUsed == RaveConstants.GTB_OTP ||
          authModelUsed == RaveConstants.ACCESS_OTP ||
          authModelUsed.contains("OTP")) {
        onOtpRequested(response.chargeResponseMessage);
        return;
      }

      _onNoAuthUsed();
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }

  _onPinRequested() {
    var state = TransactionState(
      state: State.pin,
      callback: (pin) {
        if (pin != null && pin.length == 4) {
          payload
            ..pin = pin
            ..suggestedAuth = RaveConstants.PIN;
          _handlePinOrBillingInput();
        } else {
          handleError(e: RaveException(data: "PIN must be exactly 4 digits"));
        }
      },
    );
    transactionBloc.setState(
      state,
    );
  }

  _onBillingRequest() {
    transactionBloc.setState(
      TransactionState(
          state: State.avsSecure,
          callback: (map) {
            payload
              ..suggestedAuth = RaveConstants.NO_AUTH_INTERNATIONAL
              ..billingAddress = map["address"]
              ..billingCity = map["city"]
              ..billingZip = map["zip"]
              ..billingCountry = map["counntry"]
              ..billingState = map["state"];
            _handlePinOrBillingInput();
          }),
    );
  }

  _onNoAuthUsed() => reQueryTransaction();

  _onAVSVBVSecureCodeModelUsed(String authUrl) => showWebAuthorization(authUrl);

  _handlePinOrBillingInput() async {
    setConnectionState(ConnectionState.waiting);

    try {
      var response =
          await service.charge(ChargeRequestBody.fromPayload(payload: payload));
      setConnectionState(ConnectionState.done);

      flwRef = response.flwRef;

      var responseCode = response.chargeResponseCode;

      if (response.hasData && responseCode != null) {
        if (responseCode == "00") {
          reQueryTransaction();
        } else if (responseCode == "02") {
          var authModel = response.authModelUsed?.toUpperCase();
          if (authModel == RaveConstants.PIN) {
            onOtpRequested(response.chargeResponseMessage);
          } else if (authModel == RaveConstants.AVS_VBVSECURECODE ||
              authModel == RaveConstants.VBV) {
            _onAVSVBVSecureCodeModelUsed(response.authUrl);
          } else {
            reQueryTransaction();
          }
        } else {
          reQueryTransaction();
        }
      } else {
        reQueryTransaction();
      }
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }
}
