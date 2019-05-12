import 'package:flutter/material.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class CardPaymentWidget extends BasePaymentPage {
  @override
  _CardPaymentWidgetState createState() => _CardPaymentWidgetState();
}

class _CardPaymentWidgetState extends BasePaymentPageState<CardPaymentWidget> {
  @override
  Widget buildPage(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.red,
    );
  }
}
