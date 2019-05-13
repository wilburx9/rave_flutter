import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/widgets/common/input_formatters.dart';
import 'package:rave_flutter/src/widgets/fields/base_field.dart';

class CardNumberField extends BaseTextField {
  CardNumberField(
      {@required TextEditingController controller,
      @required FormFieldSetter<String> onSaved,
      @required Widget suffix})
      : super(
          labelText: 'CARD NUMBER',
          hintText: '0000 0000 0000 0000',
          controller: controller,
          onSaved: onSaved,
          suffixIcon: suffix,
          validator: (String value) => validateCardNum(value),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(19),
            new CardNumberInputFormatter()
          ],
        );

  static String validateCardNum(String input) {
    return ValidatorUtils.isCardNumberValid(input) ? null : Strings.invalidCardNumber;
  }

  @override
  createState() {
    return super.createState();
  }
}


enum CardType {visa, master, amex, diners, discover, jcb, verve, unknown}