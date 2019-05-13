import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class GhMobileMoneyPaymentWidget extends BasePaymentPage {
  GhMobileMoneyPaymentWidget(RavePayInitializer initializer) : super(initializer);

  @override
  _GhMobileMoneyPaymentWidgetState createState() => _GhMobileMoneyPaymentWidgetState();
}

class _GhMobileMoneyPaymentWidgetState extends BasePaymentPageState<GhMobileMoneyPaymentWidget> {
  @override
  List<Widget> buildFormChildren() {
    return [
      Container(
        width: double.infinity,
        height: 200,
      )
    ];
  }

  @override
  onFormValidated() {
    // TODO: implement onFormValidated
    return null;
  }
}
