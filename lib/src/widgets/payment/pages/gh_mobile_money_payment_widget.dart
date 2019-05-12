import 'package:flutter/material.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class GhMobileMoneyPaymentWidget extends BasePaymentPage {
  @override
  _GhMobileMoneyPaymentWidgetState createState() => _GhMobileMoneyPaymentWidgetState();
}

class _GhMobileMoneyPaymentWidgetState extends BasePaymentPageState<GhMobileMoneyPaymentWidget> {
  @override
  Widget buildPage(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.purple,
    );
  }
}
