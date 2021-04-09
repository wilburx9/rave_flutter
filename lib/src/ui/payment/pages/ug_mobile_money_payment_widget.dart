import 'package:flutter/material.dart';
import 'package:rave_flutter/src/manager/ug_mm_transaction_manager.dart';
import 'package:rave_flutter/src/ui/fields/phone_number_field.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';

class UgMobileMoneyPaymentWidget extends BasePaymentPage {
  UgMobileMoneyPaymentWidget({required UgMMTransactionManager manager})
      : super(transactionManager: manager);

  @override
  _UgMobileMoneyPaymentWidgetState createState() =>
      _UgMobileMoneyPaymentWidgetState();
}

class _UgMobileMoneyPaymentWidgetState
    extends BasePaymentPageState<UgMobileMoneyPaymentWidget> {
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
          hintText: '256xxxxxxxxx',
          onFieldSubmitted: (value) => swapFocus(_phoneFocusNode),
          onSaved: (value) => payload!.phoneNumber),
    ];
  }

  @override
  onFormValidated() {
    // TODO: implement onFormValidated
    super.onFormValidated();
    return null;
  }

  @override
  FocusNode getNextFocusNode() => _phoneFocusNode;

  @override
  bool showEmailField() => false;

  @override
  bool get supported => false;
}
