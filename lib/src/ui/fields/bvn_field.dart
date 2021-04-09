import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class BVNField extends BaseTextField {
  BVNField({
    required FormFieldSetter<String> onSaved,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
  }) : super(
          labelText: 'BVN',
          hintText: '123456789',
          onSaved: onSaved,
          validator: (String? value) => validatePhoneNum(value),
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11)
          ],
        );

  static String? validatePhoneNum(String? input) {
    return ValidatorUtils.isBVNValid(input) ? null : Strings.invalidBVN;
  }
}
