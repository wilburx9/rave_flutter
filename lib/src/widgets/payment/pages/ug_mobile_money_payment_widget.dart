import 'package:flutter/material.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class UgMobileMoneyPaymentWidget extends BasePaymentPage {
  @override
  _UgMobileMoneyPaymentWidgetState createState() => _UgMobileMoneyPaymentWidgetState();
}

class _UgMobileMoneyPaymentWidgetState
    extends BasePaymentPageState<UgMobileMoneyPaymentWidget> {
  @override
  Widget buildPage(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.amber,
    );
  }
}
