import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rave_flutter/rave_flutter.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/common/rave_constants.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/dto/fee_check_request_body.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/models/charge_model.dart';
import 'package:rave_flutter/src/models/fee_check_model.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/services/transaction_service.dart';

class TransactionManager {
  final TransactionService _service = TransactionService.instance;
  final BuildContext _context;
  final TransactionComplete _onTransactionComplete;
  final RavePayInitializer initializer = Repository.instance.initializer;

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
    _setDataState(DataState.waiting);
    try {
      var response =
          await _service.fetchFee(FeeCheckRequestBody.fromPayload(payload));
      _setDataState(DataState.done);
      _displayFeeDialog(response, payload);
    } on RaveException catch (e) {
      _handleError(e);
    }
  }

  _charge(Payload payload) async {
    _setDataState(DataState.waiting);
    try {
      var response =
          await _service.charge(ChargeRequestBody.fromPayload(payload));
      _setDataState(DataState.done);
      _handleChargeResult(response, payload);
    } on RaveException catch (e) {
      _handleError(e);
    }
  }

  _handleChargeResult(ChargeResponseModel response, Payload payload) {
    _setDataState(DataState.done);
    if (response.hasValidData()) {
      var suggestedAuth = response.suggestedAuth?.toUpperCase();
      if (suggestedAuth != null) {
        if (suggestedAuth == RaveConstants.PIN) {
          _onPinSuggested(payload);
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
            _onVBVAuthModelUsed(response.authUrl, response.flwRef);
          } else if (authModelUsed == RaveConstants.GTB_OTP ||
              authModelUsed == RaveConstants.ACCESS_OTP ||
              authModelUsed.contains("OTP")) {
            _onOtpRequested(response.flwRef,
                response.chargeResponseMessage ?? Strings.enterOtp);
          } else if (authModelUsed == RaveConstants.NO_AUTH) {
            _onNoAuthUsed(response.flwRef, payload.pbfPubKey);
          }
        }
      }
    } else {
      _handleError(RaveException(data: Strings.noResponseData));
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
    _setDataState(DataState.done);
    _onTransactionComplete(
        RaveResult(status: RaveStatus.error, message: e.message));
  }

  void _setDataState(DataState state) =>
      ConnectionBloc.instance.setState(state);

  void _onPinSuggested(Payload payload) {}

  void _onAVSSecureModelSuggested(Payload payload) {}

  void _onNoAuthInternationalSuggested(Payload payload) {}

  void _onVBVAuthModelUsed(String authUrl, String flwRef) {}

  void _onOtpRequested(String flwRef, String message) {}

  void _onNoAuthUsed(String flwRef, String pbfPubKey) {}
}

typedef void TransactionComplete(RaveResult result);
