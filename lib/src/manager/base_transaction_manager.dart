import 'dart:io';

import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/dto/fee_check_request_body.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/dto/validate_charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/models/fee_check_model.dart';
import 'package:rave_flutter/src/models/requery_model.dart';
import 'package:rave_flutter/src/rave_result.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/services/transaction_service.dart';
import 'package:rave_flutter/src/ui/common/webview_widget.dart';

abstract class BaseTransactionManager {
  final TransactionService service = TransactionService.instance;
  final BuildContext context;
  final TransactionComplete onTransactionComplete;
  final RavePayInitializer initializer = Repository.instance.initializer;
  final transactionBloc = TransactionBloc.instance;
  final connectionBloc = ConnectionBloc.instance;
  Payload payload;
  String flwRef;

  BaseTransactionManager(
      {@required this.context, @required this.onTransactionComplete});

  processTransaction(Payload payload) {
    this.payload = payload;
    if (initializer.displayFee) {
      fetchFee();
    } else {
      charge();
    }
  }

  charge();

  fetchFee() async {
    setConnectionState(ConnectionState.waiting);
    try {
      var response =
          await service.fetchFee(FeeCheckRequestBody.fromPayload(payload));
      setConnectionState(ConnectionState.done);
      displayFeeDialog(response);
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }

  reQueryTransaction({ValueChanged<ReQueryResponseModel> onComplete}) async {
    onComplete ??= this.onComplete;
    setConnectionState(ConnectionState.waiting);
    try {
      var response = await service.reQuery(payload.pbfPubKey, flwRef);
      onComplete(response);
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }

  onOtpRequested([String message = Strings.enterOtp]) {
    transactionBloc.setState(TransactionState(
        state: State.otp,
        data: message,
        callback: (otp) {
          _validateCharge(otp);
        }));
  }

  showWebAuthorization(String authUrl) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => WebViewWidget(
                authUrl: cleanUrl(authUrl),
                callbackUrl: cleanUrl(payload.redirectUrl),
              ),
          fullscreenDialog: true),
    );
    reQueryTransaction();
  }

  _validateCharge(otp) async {
    try {
      setConnectionState(ConnectionState.waiting);
      var response = await service.validateCardCharge(ValidateChargeRequestBody(
          transactionReference: flwRef,
          otp: otp,
          pBFPubKey: payload.pbfPubKey));
      setConnectionState(ConnectionState.done);

      var status = response.status;
      if (status == null) {
        reQueryTransaction();
        return;
      }

      if (status.toLowerCase() == "success") {
        reQueryTransaction();
      } else {
        onTransactionComplete(RaveResult(
          status: RaveStatus.error,
          message: response.message,
        ));
      }
    } catch (e) {
      reQueryTransaction();
    }
  }

  displayFeeDialog(FeeCheckResponseModel model) {
    closeDialog() {
      Navigator.of(context).pop();
      handleError(e: RaveException(data: "You cancelled"));
    }

    charge() async {
      Navigator.of(context).pop();
      this.charge();
    }

    var content = Text(
        "You will be charged a total of ${model.chargeAmount} ${initializer.currency}. Do you want to continue?");

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

    showDialog(context: context, builder: (_) => child);
  }

  @mustCallSuper
  handleError({@required RaveException e, Map rawResponse}) {
    setConnectionState(ConnectionState.done);
    onTransactionComplete(RaveResult(
        status: RaveStatus.error,
        message: e.message,
        rawResponse: rawResponse));
  }

  @mustCallSuper
  onComplete(ReQueryResponseModel response) {
    setConnectionState(ConnectionState.done);
    onTransactionComplete(RaveResult(
        status: response.dataStatus.toLowerCase() == "successful"
            ? RaveStatus.success
            : RaveStatus.error,
        rawResponse: response.rawResponse,
        message: response.message));
  }

  setConnectionState(ConnectionState state) => connectionBloc.setState(state);
}

typedef TransactionComplete(RaveResult result);
