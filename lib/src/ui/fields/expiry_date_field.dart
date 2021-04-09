import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/ui/common/input_formatters.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class ExpiryDateField extends BaseTextField {
  ExpiryDateField({
    required FormFieldSetter<String> onSaved,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
  }) : super(
          labelText: 'CARD EXPIRY',
          hintText: 'MM/YY',
          validator: validateDate,
          onSaved: onSaved,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(4),
            new CardMonthInputFormatter()
          ],
        );

  static String? validateDate(String? value) {
    if (value!.isEmpty) {
      return Strings.invalidExpiry;
    }

    int? year;
    int? month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(new RegExp(r'(\/)'))) {
      var split = value.split(new RegExp(r'(\/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.tryParse(split[0]);
      year = int.tryParse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if (!ValidatorUtils.validExpiryDate(month, year))
      return Strings.invalidExpiry;

    return null;
  }
}
