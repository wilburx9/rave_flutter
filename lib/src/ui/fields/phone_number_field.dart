import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class PhoneNumberField extends BaseTextField {
  PhoneNumberField({
    required FormFieldSetter<String> onSaved,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    String hintText = '080XXXXXXXX',
    ValueChanged<String>? onFieldSubmitted,
  }) : super(
          labelText: 'PHONE NUMBER',
          hintText: hintText,
          onSaved: onSaved,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          validator: (String? value) => validatePhoneNum(value),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        );

  static String? validatePhoneNum(String? input) {
    return ValidatorUtils.isPhoneValid(input)
        ? null
        : Strings.invalidPhoneNumber;
  }
}
