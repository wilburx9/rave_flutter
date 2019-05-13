import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/widgets/fields/base_field.dart';

class AmountField extends BaseTextField {
  AmountField({
    @required FormFieldSetter<String> onSaved,
    @required String currency,
    TextEditingController controller,
  }) : super(
          labelText: 'AMOUNT',
          hintText: '0.0',
          onSaved: onSaved,
          prefix: Text('$currency '),
          controller: controller,
          prefixStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),
          validator: (String value) => validateNum(value),
    
        );

  static String validateNum(String input) {
    return ValidatorUtils.isAmountValid(input) ? null : Strings.invalidAmount;
  }
}

