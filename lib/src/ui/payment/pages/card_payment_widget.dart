import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rave_flutter/src/manager/card_transaction_manager.dart';
import 'package:rave_flutter/src/ui/common/card_utils.dart';
import 'package:rave_flutter/src/ui/fields/cvc_field.dart';
import 'package:rave_flutter/src/ui/fields/expiry_date_field.dart';
import 'package:rave_flutter/src/ui/fields/card_number_field.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardPaymentWidget extends BasePaymentPage {
  CardPaymentWidget({required CardTransactionManager manager})
      : super(transactionManager: manager);

  @override
  _CardPaymentWidgetState createState() => _CardPaymentWidgetState();
}

class _CardPaymentWidgetState extends BasePaymentPageState<CardPaymentWidget> {
  TextEditingController? numberController;
  CardType cardType = CardType.unknown;
  var _numberFocusNode = FocusNode();
  var _expiryFocusNode = FocusNode();
  var _cvvFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    numberController = new TextEditingController();
    numberController!.addListener(_setCardTypeFrmNumber);
  }

  @override
  void dispose() {
    numberController!.removeListener(_setCardTypeFrmNumber);
    numberController!.dispose();
    super.dispose();
  }

  @override
  List<Widget> buildLocalFields([data]) {
    return [
      CardNumberField(
        controller: numberController,
        focusNode: _numberFocusNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            swapFocus(_numberFocusNode, _expiryFocusNode),
        onSaved: (value) => payload!.cardNo = CardUtils.getCleanedNumber(value),
        suffix: SvgPicture.asset(
          'assets/images/${CardUtils.getCardIcon(cardType)}.svg',
          package: 'rave_flutter',
          width: 30,
          height: 15,
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ExpiryDateField(
              focusNode: _expiryFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) =>
                  swapFocus(_expiryFocusNode, _cvvFocusNode),
              onSaved: (value) {
                List<String> expiryDate = CardUtils.getExpiryDate(value!);
                payload!.expiryMonth = expiryDate[0];
                payload!.expiryYear = expiryDate[1];
              },
            ),
          ),
          Expanded(
            child: CVVField(
                focusNode: _cvvFocusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) => swapFocus(
                      _cvvFocusNode,
                    ),
                onSaved: (value) => payload!.cvv = value),
          ),
        ],
      )
    ];
  }

  void _setCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController!.text);
    setState(() {
      cardType = CardUtils.getTypeForIIN(input);
    });
  }

  @override
  FocusNode getNextFocusNode() => _numberFocusNode;
}
