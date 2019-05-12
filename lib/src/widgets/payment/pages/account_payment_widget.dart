import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class AccountPaymentWidget extends BasePaymentPage {
  AccountPaymentWidget(RavePayInitializer initializer) : super(initializer);

  @override
  _AccountPaymentWidgetState createState() => _AccountPaymentWidgetState();
}

class _AccountPaymentWidgetState extends BasePaymentPageState<AccountPaymentWidget> {
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
