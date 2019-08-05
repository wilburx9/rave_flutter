import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:rave_flutter/rave_flutter.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/rave_constants.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/dto/validate_charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';
import 'package:rave_flutter/src/ui/common/webview_widget.dart';

class CardTransactionManager extends BaseTransactionManager {
  CardTransactionManager(
      {@required BuildContext context,
      @required TransactionComplete onTransactionComplete})
      : super(
          context: context,
          onTransactionComplete: onTransactionComplete,
        );

  @override
  processTransaction(Payload payload) async {
    if (initializer.displayFee) {
      fetchFee(payload);
    } else {
      charge(payload);
    }
  }

  @override
  charge(Payload payload) async {
    setConnectionState(ConnectionState.waiting);
    try {
      var response =
          await service.charge(ChargeRequestBody.fromPayload(payload));

      setConnectionState(ConnectionState.done);

      print("ChargerResponse = $response");
      if (response.hasData) {
        var suggestedAuth = response.suggestedAuth?.toUpperCase();
        if (suggestedAuth != null) {
          if (suggestedAuth == RaveConstants.PIN) {
            _onPinRequested(payload);
          } else if (suggestedAuth == RaveConstants.AVS_VBVSECURECODE) {
            _onAVSSecureModelSuggested(payload);
          } else if (suggestedAuth == RaveConstants.NO_AUTH_INTERNATIONAL) {
            _onNoAuthInternationalSuggested(payload);
          } else {
            handleError(RaveException(data: Strings.unknownAuthModel));
          }
        } else {
          String authModelUsed = response.authModelUsed?.toUpperCase();
          if (authModelUsed != null) {
            if (authModelUsed == RaveConstants.VBV) {
              _onVBVAuthModelUsed(payload, response.authUrl, response.flwRef);
            } else if (authModelUsed == RaveConstants.GTB_OTP ||
                authModelUsed == RaveConstants.ACCESS_OTP ||
                authModelUsed.contains("OTP")) {
              _onOtpRequested(payload, response.flwRef,
                  response.chargeResponseMessage ?? Strings.enterOtp);
            } else if (authModelUsed == RaveConstants.NO_AUTH) {
              _onNoAuthUsed(payload, response.flwRef);
            }
          }
        }
      } else {
        handleError(RaveException(data: Strings.noResponseData));
      }
    } on RaveException catch (e) {
      handleError(e);
    }
  }


  _onPinRequested(Payload payload) {
    var state = TransactionState(
      state: State.pin,
      callback: (pin) {
        if (pin != null && pin.length == 4) {
          _handlePinOrBillingInput(payload
            ..pin = pin
            ..suggestedAuth = RaveConstants.PIN);
        } else {
          handleError(RaveException(data: "PIN must be exactly 4 digits"));
        }
      },
    );
    transactionBloc.setState(
      state,
    );
  }

  _onAVSSecureModelSuggested(Payload payload) {
    transactionBloc.setState(
      TransactionState(
          state: State.avsSecure,
          callback: (map) {
            var p = payload
              ..suggestedAuth = RaveConstants.NO_AUTH_INTERNATIONAL
              ..billingAddress = map["address"]
              ..billingCity = map["city"]
              ..billingZip = map["zip"]
              ..billingCountry = map["counntry"]
              ..billingState = map["state"];
            _handlePinOrBillingInput(p);
          }),
    );
  }

  _onNoAuthInternationalSuggested(Payload payload) =>
      _onAVSSecureModelSuggested(payload);

  _onVBVAuthModelUsed(Payload payload, String authUrl, String flwRef) =>
      _onAVSVBVSecureCodeModelUsed(payload, authUrl, flwRef);

  _onOtpRequested(Payload payload, String flwRef, String message) {
    transactionBloc.setState(TransactionState(
        state: State.otp,
        data: message,
        callback: (otp) {
          _validateCharge(payload, flwRef, otp);
        }));
  }

  _onNoAuthUsed(Payload payload, String flwRef) =>
      reQueryTransaction(payload, flwRef);

  _onAVSVBVSecureCodeModelUsed(
      Payload payload, String authUrl, String flwRef) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewWidget(
          authUrl: authUrl,
        ),
      ),
    );
    reQueryTransaction(payload, flwRef);
  }

  _handlePinOrBillingInput(Payload payload) async {
    setConnectionState(ConnectionState.waiting);

    try {
      var response =
          await service.charge(ChargeRequestBody.fromPayload(payload));
      setConnectionState(ConnectionState.done);

      print("Charge response (PIN) = $response");

      var responseCode = response.chargeResponseCode;

      if (response.hasData && responseCode != null) {
        if (responseCode == "00") {
          reQueryTransaction(payload, response.flwRef);
        } else if (responseCode == "02") {
          var authModel = response.authModelUsed?.toUpperCase();
          if (authModel == RaveConstants.PIN) {
            _onOtpRequested(
                payload, response.flwRef, response.chargeResponseMessage);
          } else if (authModel == RaveConstants.AVS_VBVSECURECODE ||
              authModel == RaveConstants.VBV) {
            _onAVSVBVSecureCodeModelUsed(
                payload, response.authUrl, response.flwRef);
          } else {
            handleError(RaveException(data: "Unknown Auth Model"));
          }
        } else {
          handleError(RaveException(data: "Unknown charge response code"));
        }
      } else {
        handleError(RaveException(data: "Invalid charge response code"));
      }
    } on RaveException catch (e) {
      handleError(e);
    }
  }

  _validateCharge(Payload payload, String flwRef, otp) async {
    setConnectionState(ConnectionState.waiting);
    var response = await service.validateCardCharge(ValidateChargeRequestBody(
        transactionReference: flwRef, otp: otp, pBFPubKey: payload.pbfPubKey));
    setConnectionState(ConnectionState.done);

    print("Validate charge = $response");

    var status = response.status;
    if (status == null) {
      reQueryTransaction(payload, flwRef);
      return;
    }

    if (status.toLowerCase() == "success") {
      reQueryTransaction(payload, flwRef);
    } else {
      onTransactionComplete(RaveResult(
        status: RaveStatus.error,
        message: response.message,
      ));
    }
  }
}

