import 'package:flutter/material.dart';
import 'package:rave_flutter/src/manager/ach_transaction_manager.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';

class AchPaymentWidget extends BasePaymentPage {
  AchPaymentWidget({required AchTransactionManager manager})
      : super(transactionManager: manager);

  @override
  _AchPaymentWidgetState createState() => _AchPaymentWidgetState();
}

class _AchPaymentWidgetState extends BasePaymentPageState<AchPaymentWidget> {
  @override
  List<Widget> buildLocalFields([data]) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'You will be redirected to your US bank account to complete this payment',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[800], fontSize: 16),
        ),
      )
    ];
  }

  @override
  bool showEmailField() => false;

  @override
  FocusNode? getNextFocusNode() => null;
}
