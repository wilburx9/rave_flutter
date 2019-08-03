import 'dart:io';

import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:rave_flutter/rave_flutter.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/rave_constants.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/dto/fee_check_request_body.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/dto/validate_charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/models/fee_check_model.dart';
import 'package:rave_flutter/src/models/requery_model.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/services/transaction_service.dart';
import 'package:rave_flutter/src/ui/common/webview_widget.dart';

class TransactionManager {
  final TransactionService _service = TransactionService.instance;
  final BuildContext _context;
  final TransactionComplete _onTransactionComplete;
  final RavePayInitializer initializer = Repository.instance.initializer;
  final _transactionBloc = TransactionBloc.instance;
  final _connectionBloc = ConnectionBloc.instance;

  TransactionManager(
      {@required BuildContext context,
      @required TransactionComplete onTransactionComplete})
      : this._context = context,
        this._onTransactionComplete = onTransactionComplete;

  start(Payload payload) async {
    if (initializer.displayFee) {
      _fetchFee(payload);
    } else {
      _charge(payload);
    }
  }

  _fetchFee(Payload payload) async {
    _setConnectionState(ConnectionState.waiting);
    try {
      var response =
          await _service.fetchFee(FeeCheckRequestBody.fromPayload(payload));
      _setConnectionState(ConnectionState.done);
      _displayFeeDialog(response, payload);
    } on RaveException catch (e) {
      _handleError(e);
    }
  }

  _charge(Payload payload) async {
    _setConnectionState(ConnectionState.waiting);
    try {
      var response =
          await _service.charge(ChargeRequestBody.fromPayload(payload));

      _setConnectionState(ConnectionState.done);

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
            _handleError(RaveException(data: Strings.unknownAuthModel));
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
        _handleError(RaveException(data: Strings.noResponseData));
      }
    } on RaveException catch (e) {
      _handleError(e);
    }
  }

  void _displayFeeDialog(FeeCheckResponseModel model, Payload payload) {
    void closeDialog() {
      Navigator.of(_context).pop();
      _handleError(RaveException(data: "You cancelled"));
    }

    charge() async {
      Navigator.of(_context).pop();
      _charge(payload);
    }

    var content = Text(
        "You will be charged a total of ${model.chargeAmount}${initializer.currency}. Do you want to continue?");

    Widget child;
    if (Platform.isIOS) {
      child = CupertinoAlertDialog(
        content: content,
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Yes"),
            isDestructiveAction: true,
            onPressed: charge,
          ),
          CupertinoDialogAction(
            child: Text('No'),
            isDefaultAction: true,
            onPressed: closeDialog,
          )
        ],
      );
    } else {
      child = AlertDialog(
        content: content,
        actions: <Widget>[
          FlatButton(onPressed: closeDialog, child: Text('NO')),
          FlatButton(onPressed: charge, child: Text('YES'))
        ],
      );
    }

    showDialog(context: _context, builder: (_) => child);
  }

  _handleError(RaveException e) {
    print("Error called");
    _setConnectionState(ConnectionState.done);
    _onTransactionComplete(
        RaveResult(status: RaveStatus.error, message: e.message));
  }

  _onComplete(ReQueryResponseModel response) {
    _setConnectionState(ConnectionState.done);
    _onTransactionComplete(RaveResult(
        status: response.dataStatus.toLowerCase() == "successful"
            ? RaveStatus.success
            : RaveStatus.error,
        rawResponse: response.json,
        message: response.message));
  }

  void _setConnectionState(ConnectionState state) =>
      _connectionBloc.setState(state);

  void _onPinRequested(Payload payload) {
    var state = TransactionState(
      state: State.pin,
      callback: (pin) {
        if (pin != null && pin.length == 4) {
          _handlePinOrBillingInput(payload
            ..pin = pin
            ..suggestedAuth = RaveConstants.PIN);
        } else {
          _handleError(RaveException(data: "PIN must be exactly 4 digits"));
        }
      },
    );
    _transactionBloc.setState(
      state,
    );
  }

  void _onAVSSecureModelSuggested(Payload payload) {
    _transactionBloc.setState(
      TransactionState(
          state: State.avsSecure,
          callback: (map) {
            _handlePinOrBillingInput(payload
              ..suggestedAuth = RaveConstants.NO_AUTH_INTERNATIONAL
              ..billingAddress = map["address"]
              ..billingCity = map["city"]
              ..billingZip = map["zip"]
              ..billingCountry = map["counntry"]
              ..billingState = map["state"]);
          }),
    );
  }

  void _onNoAuthInternationalSuggested(Payload payload) =>
      _onAVSSecureModelSuggested(payload);

  void _onVBVAuthModelUsed(Payload payload, String authUrl, String flwRef) =>
      _onAVSVBVSecureCodeModelUsed(payload, authUrl, flwRef);

  void _onOtpRequested(Payload payload, String flwRef, String message) {
    _transactionBloc.setState(TransactionState(
        state: State.otp,
        data: message,
        callback: (otp) {
          _validateCharge(payload, flwRef, otp);
        }));
  }

  void _onNoAuthUsed(Payload payload, String flwRef) =>
      _reQueryTransaction(payload, flwRef);

  void _onAVSVBVSecureCodeModelUsed(
      Payload payload, String authUrl, String flwRef) async {
    await Navigator.of(_context).push(
      MaterialPageRoute(
        builder: (_) => WebViewWidget(
          authUrl: authUrl,
        ),
      ),
    );
    _reQueryTransaction(payload, flwRef);
  }

  void _handlePinOrBillingInput(Payload payload) async {
    _setConnectionState(ConnectionState.waiting);

    try {
      var response =
          await _service.charge(ChargeRequestBody.fromPayload(payload));
      _setConnectionState(ConnectionState.done);

      print("Charge response (PIN) = $response");

      var responseCode = response.chargeResponseCode;

      if (response.hasData && responseCode != null) {
        if (responseCode == "00") {
          _reQueryTransaction(payload, response.flwRef);
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
            _handleError(RaveException(data: "Unknown Auth Model"));
          }
        } else {
          _handleError(RaveException(data: "Unknown charge response code"));
        }
      } else {
        _handleError(RaveException(data: "Invalid charge response code"));
      }
    } on RaveException catch (e) {
      _handleError(e);
    }
  }

  void _reQueryTransaction(Payload payload, String flwRef) async {
    _setConnectionState(ConnectionState.waiting);
    try {
      var response = await _service.reQuery(payload.pbfPubKey, flwRef);
      _onComplete(response);
    } on RaveException catch (e) {
      _handleError(e);
    }
  }

  void _validateCharge(Payload payload, String flwRef, otp) async {
    _setConnectionState(ConnectionState.waiting);
    var response = await _service.validateCardCharge(ValidateChargeRequestBody(
        transactionReference: flwRef, otp: otp, pBFPubKey: payload.pbfPubKey));
    _setConnectionState(ConnectionState.done);

    print("Validate charge = $response");

    var status = response.status;
    if (status == null) {
      _reQueryTransaction(payload, flwRef);
      return;
    }

    if (status.toLowerCase() == "success") {
      _reQueryTransaction(payload, flwRef);
    } else {
      _onTransactionComplete(RaveResult(
        status: RaveStatus.error,
        message: response.message,
      ));
    }
  }
}

typedef void TransactionComplete(RaveResult result);
