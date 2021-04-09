import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class AmountField extends BaseTextField {
  AmountField({
    required FormFieldSetter<String> onSaved,
    required String currency,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
    TextEditingController? controller,
  }) : super(
          labelText: 'AMOUNT',
          hintText: '0.0',
          onSaved: onSaved,
          prefix: Text('$currency '.toUpperCase()),
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          prefixStyle:
              TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),
          validator: (String? value) => validateNum(value),
        );

  static String? validateNum(String? input) {
    return ValidatorUtils.isAmountValid(input) ? null : Strings.invalidAmount;
  }
}
