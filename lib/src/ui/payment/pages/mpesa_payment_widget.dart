import 'package:flutter/material.dart';
import 'package:rave_flutter/src/manager/mpesa_transaction_manager.dart';
import 'package:rave_flutter/src/ui/fields/phone_number_field.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';

class MpesaPaymentWidget extends BasePaymentPage {
  MpesaPaymentWidget({@required MpesaTransactionManager manager})
      : super(transactionManager: manager);

  @override
  _MpesaPaymentWidgetState createState() => _MpesaPaymentWidgetState();
}

class _MpesaPaymentWidgetState
    extends BasePaymentPageState<MpesaPaymentWidget> {
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
          hintText: '234xxxxxxxxx',
          onFieldSubmitted: (value) => swapFocus(_phoneFocusNode),
          onSaved: (value) => payload.phoneNumber),
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
