import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/manager/gh_mm_transaction_manager.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';
import 'package:rave_flutter/src/ui/fields/phone_number_field.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';

class GhMobileMoneyPaymentWidget extends BasePaymentPage {
  GhMobileMoneyPaymentWidget({@required GhMMTransactionManager manager})
      : super(transactionManager: manager);

  @override
  _GhMobileMoneyPaymentWidgetState createState() =>
      _GhMobileMoneyPaymentWidgetState();
}

class _GhMobileMoneyPaymentWidgetState
    extends BasePaymentPageState<GhMobileMoneyPaymentWidget> {
  var _phoneFocusNode = FocusNode();
  var _voucherFocusNode = FocusNode();
  var _networks = ['MTN', 'Tigo', 'Vodafone'];
  String _selectedNetwork;

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _voucherFocusNode.dispose();
    super.dispose();
  }

  @override
  List<Widget> buildLocalFields([data]) {
    return [
      DropdownButtonHideUnderline(
        child: InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            errorText: autoValidate && _selectedNetwork == null
                ? 'Select a network'
                : null,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey[400].withOpacity(.7), width: .5),
                borderRadius: BorderRadius.all(Radius.circular(1.5))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey[400].withOpacity(.7), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(1.5))),
            hintText: 'Select network',
          ),
          isEmpty: _selectedNetwork == null,
          child: new DropdownButton<String>(
            value: _selectedNetwork,
            isDense: true,
            onChanged: (String newValue) {
              setState(() => _selectedNetwork = newValue);
              payload.network = _selectedNetwork;
            },
            items: _networks.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ),
      ),
      PhoneNumberField(
          focusNode: _phoneFocusNode,
          textInputAction: isVodaFoneSelected()
              ? TextInputAction.next
              : TextInputAction.done,
          hintText: '233xxxxxxx',
          onFieldSubmitted: (value) => swapFocus(
              _phoneFocusNode,
              _networks.indexOf(_selectedNetwork) == 2
                  ? _voucherFocusNode
                  : null),
          onSaved: (value) => payload.phoneNumber),
      isVodaFoneSelected()
          ? BaseTextField(
              focusNode: _voucherFocusNode,
              textInputAction: TextInputAction.done,
              hintText: 'VOUCHER',
              onFieldSubmitted: (value) => swapFocus(_voucherFocusNode),
              validator: (value) =>
                  value.trim().isEmpty ? Strings.invalidVoucher : null,
              onSaved: (value) => payload.voucher)
          : SizedBox(),
    ];
  }

  bool isVodaFoneSelected() => _networks.indexOf(_selectedNetwork) == 2;

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

  @override
  Widget buildTopWidget() {
    if (isVodaFoneSelected()) {
      // This instruction is for Vodafone. Apparently, other networks don't need
      // instructions
      var textStyle =
          TextStyle(color: Colors.grey[900], fontWeight: FontWeight.normal);
      var boldStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
      return Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 25),
        child: RichText(
          text: TextSpan(text: '', style: textStyle, children: <TextSpan>[
            TextSpan(
              text:
                  'Please follow the instruction below to get your voucher code',
              style: boldStyle,
            ),
            TextSpan(text: '\n\n\n1. Dial '),
            TextSpan(text: '*110#', style: boldStyle),
            TextSpan(text: ' to generate your transaction voucher.'),
            TextSpan(text: '\n\n2. Select '),
            TextSpan(text: 'OPTION 6', style: boldStyle),
            TextSpan(text: ' to generate the voucher.'),
            TextSpan(text: '\n\n\3. Enter your PIN in next prompt.'),
            TextSpan(
                text:
                    '\n\n\4. Input the voucher generated in the voucher field below.'),
          ]),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
