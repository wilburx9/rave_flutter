import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class AchPaymentWidget extends BasePaymentPage {
  AchPaymentWidget(RavePayInitializer initializer) : super(initializer);

  @override
  _AchPaymentWidgetState createState() => _AchPaymentWidgetState();
}

class _AchPaymentWidgetState extends BasePaymentPageState<AchPaymentWidget> {
  @override
  List<Widget> buildFormChildren() {
    // TODO: implement buildFormChildren
    return null;
  }

  @override
  onFormValidated() {
    // TODO: implement onFormValidated
    return null;
  }
}
