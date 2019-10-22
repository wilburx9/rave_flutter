import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/rave_constants.dart';
import 'package:rave_flutter/src/common/strings.dart';
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

      if (response.hasData) {
        var suggestedAuth = response.suggestedAuth?.toUpperCase();
        if (suggestedAuth != null) {
          if (suggestedAuth == RaveConstants.PIN) {
            _onPinRequested();
          } else if (suggestedAuth == RaveConstants.AVS_VBVSECURECODE) {
            _onAVSSecureModelSuggested();
          } else if (suggestedAuth == RaveConstants.NO_AUTH_INTERNATIONAL) {
            _onNoAuthInternationalSuggested();
          } else {
            handleError(
              e: RaveException(data: Strings.unknownAuthModel),
              rawResponse: response.rawResponse,
            );
          }
        } else {
          String authModelUsed = response.authModelUsed?.toUpperCase();
          if (authModelUsed != null) {
            if (authModelUsed == RaveConstants.VBV) {
              _onVBVAuthModelUsed(response.authUrl);
            } else if (authModelUsed == RaveConstants.GTB_OTP ||
                authModelUsed == RaveConstants.ACCESS_OTP ||
                authModelUsed.contains("OTP")) {
              onOtpRequested(response.chargeResponseMessage);
            } else if (authModelUsed == RaveConstants.NO_AUTH) {
              _onNoAuthUsed();
            }
          }
        }
      } else {
        handleError(
          e: RaveException(data: Strings.noResponseData),
          rawResponse: response.rawResponse,
        );
      }
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

  _onAVSSecureModelSuggested() {
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

  _onNoAuthInternationalSuggested() => _onAVSSecureModelSuggested();

  _onVBVAuthModelUsed(String authUrl) => _onAVSVBVSecureCodeModelUsed(authUrl);

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
            handleError(
              e: RaveException(data: "Unknown Auth Model"),
              rawResponse: response.rawResponse,
            );
          }
        } else {
          handleError(
            e: RaveException(data: "Unknown charge response code"),
            rawResponse: response.rawResponse,
          );
        }
      } else {
        handleError(
          e: RaveException(data: "Invalid charge response code"),
          rawResponse: response.rawResponse,
        );
      }
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }
}
