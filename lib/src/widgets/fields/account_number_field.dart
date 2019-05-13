import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/widgets/fields/base_field.dart';

class AccountNumberField extends BaseTextField {
  AccountNumberField({
    @required FormFieldSetter<String> onSaved,
  }) : super(
          labelText: 'ACCOUNT NUMBER',
          hintText: '1234567789',
          onSaved: onSaved,
          validator: (String value) => validatePhoneNum(value),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10)
          ],
        );

  static String validatePhoneNum(String input) {
    return ValidatorUtils.isAccountValid(input) ? null : Strings.invalidAccountNumber;
  }
}
