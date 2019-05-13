import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/widgets/common/card_utils.dart';
import 'package:rave_flutter/src/widgets/fields/cvc_field.dart';
import 'package:rave_flutter/src/widgets/fields/date_field.dart';
import 'package:rave_flutter/src/widgets/fields/number_field.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardPaymentWidget extends BasePaymentPage {
  CardPaymentWidget(RavePayInitializer initializer) : super(initializer);

  @override
  _CardPaymentWidgetState createState() => _CardPaymentWidgetState();
}

class _CardPaymentWidgetState extends BasePaymentPageState<CardPaymentWidget> {
  TextEditingController numberController;
  CardType cardType = CardType.unknown;

  @override
  void initState() {
    super.initState();
    numberController = new TextEditingController();
    numberController.addListener(_setCardTypeFrmNumber);
  }

  @override
  void dispose() {
    numberController.removeListener(_setCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  @override
  List<Widget> buildFormChildren() {
    return [
      NumberField(
        controller: numberController,
        onSaved: (value) => payload.cardNo = CardUtils.getCleanedNumber(value),
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
            child: DateField(
              onSaved: (value) {
                List<String> expiryDate = CardUtils.getExpiryDate(value);
                payload.expiryMonth = expiryDate[0];
                payload.expiryYear = expiryDate[0];
              },
            ),
          ),
          Expanded(
            child: CVVField(onSaved: (value) => payload.cvv = value),
          ),
        ],
      )
    ];
  }


  @override
  onFormValidated() {
    // TODO: implement onFormValidated
    return null;
  }

  void _setCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    setState(() {
      cardType = CardUtils.getTypeForIIN(input);
    });
  }

  @override
  bool showRaveCredits() => true;


}
