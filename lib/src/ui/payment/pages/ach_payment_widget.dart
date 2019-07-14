import 'package:flutter/material.dart';
import 'package:rave_flutter/src/ui/fields/phone_number_field.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';

class AchPaymentWidget extends BasePaymentPage {

  @override
  _AchPaymentWidgetState createState() => _AchPaymentWidgetState();
}

class _AchPaymentWidgetState extends BasePaymentPageState<AchPaymentWidget> {
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
          hintText: '123456789',
          onFieldSubmitted: (value) => swapFocus(_phoneFocusNode),
          onSaved: (value) => payload.phoneNumber),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'You will be redirected to your US bank account to complete this payment',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[800], fontSize: 16),
        ),
      )
    ];
  }

  @override
  onFormValidated() {
    // TODO: implement onFormValidated
    return null;
  }

  @override
  FocusNode getNextFocusNode() => _phoneFocusNode;

  @override
  bool showEmailField() => false;
}
