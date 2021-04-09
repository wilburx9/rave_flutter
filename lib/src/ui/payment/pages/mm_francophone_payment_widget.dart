import 'package:flutter/material.dart';
import 'package:rave_flutter/src/manager/mm_francoophone_transaction_manager.dart';
import 'package:rave_flutter/src/ui/fields/phone_number_field.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';

class MobileMoneyFrancophonePaymentWidget extends BasePaymentPage {
  MobileMoneyFrancophonePaymentWidget(
      {required MMFrancophoneTransactionManager manager})
      : super(transactionManager: manager);

  @override
  _MobileMoneyFrancophonePaymentWidgetState createState() =>
      _MobileMoneyFrancophonePaymentWidgetState();
}

class _MobileMoneyFrancophonePaymentWidgetState
    extends BasePaymentPageState<MobileMoneyFrancophonePaymentWidget> {
  var _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  List<Widget> buildLocalFields([data]) {
    return [
      PhoneNumberField(
          focusNode: _phoneFocusNode,
          textInputAction: TextInputAction.done,
          hintText: '054xxxxxxxxx',
          onFieldSubmitted: (value) => swapFocus(_phoneFocusNode),
          onSaved: (value) => payload!.phoneNumber = value),
    ];
  }

  @override
  onFormValidated() => super.onFormValidated();

  @override
  FocusNode getNextFocusNode() => _phoneFocusNode;

  @override
  bool showEmailField() => false;

  @override
  bool get supported => true;
}
