import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class UgMobileMoneyPaymentWidget extends BasePaymentPage {
  UgMobileMoneyPaymentWidget(RavePayInitializer initializer) : super(initializer);

  @override
  _UgMobileMoneyPaymentWidgetState createState() => _UgMobileMoneyPaymentWidgetState();
}

class _UgMobileMoneyPaymentWidgetState
    extends BasePaymentPageState<UgMobileMoneyPaymentWidget> {
  @override
  List<Widget> buildFormChildren() {
    return [];
  }

  @override
  onFormValidated() {
    // TODO: implement onFormValidated
    return null;
  }
}
