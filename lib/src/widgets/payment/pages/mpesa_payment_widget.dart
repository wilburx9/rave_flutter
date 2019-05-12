import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';

class MpesaPaymentWidget extends BasePaymentPage {
  MpesaPaymentWidget(RavePayInitializer initializer) : super(initializer);

  @override
  _MpesaPaymentWidgetState createState() => _MpesaPaymentWidgetState();
}

class _MpesaPaymentWidgetState extends BasePaymentPageState<MpesaPaymentWidget> {
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
