import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/widgets/fields/base_field.dart';

class EmailField extends BaseTextField {
  EmailField({
    @required FormFieldSetter<String> onSaved,
    TextEditingController controller,
  }) : super(
          labelText: 'EMAIL',
          hintText: 'EXAMPLE@EMAIL.COM',
          onSaved: onSaved,
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          validator: (String value) => validateNum(value),
        );

  static String validateNum(String input) {
    return ValidatorUtils.isEmailValid(input) ? null : Strings.invalidEmail;
  }
}
