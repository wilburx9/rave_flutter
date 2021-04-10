import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/rave_result.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/ui/payment/rave_pay_widget.dart';

class RavePayManager {
  RavePayManager._internal();

  static final RavePayManager _manager = RavePayManager._internal();

  factory RavePayManager() {
    return _manager;
  }

  /// {@macro rave_flutter.rave_pay_manager.prompt}
  @Deprecated(
      "'initilize' doesn't properly communicate the purpose of this function. Use the `prompt` function. Will be removed in version 1.0.0")
  Future<RaveResult> initialize({
    required BuildContext context,
    required RavePayInitializer initializer,
  }) async {
    return prompt(context: context, initializer: initializer);
  }

  /// {@template rave_flutter.rave_pay_manager.prompt}
  /// Prompts the customer to input payment details
  /// if the correct parameters are passed.
  ///
  /// [context] Your immediate build context.
  ///
  /// [initializer] Container for the transaction parameters
  ///
  ///
  /// Please, enable embedded_views_preview on iOS. See https://stackoverflow.com/a/55290868/6181476
  ///  {@endtemplate}
  Future<RaveResult> prompt({
    required BuildContext context,
    required RavePayInitializer initializer,
  }) async {
    // Validate the initializer params
    var error = ValidatorUtils.validateInitializer(initializer);
    if (error != null) {
      return RaveResult(
          status: RaveStatus.error,
          rawResponse: {'error': error},
          message: error);
    }

    Repository.bootStrap(initializer);

    var result = await showDialog<RaveResult?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Theme(
        data: _getDefaultTheme(context),
        child: RavePayWidget(),
      ),
    );

    // Return a cancelled response if result is null
    return result ?? RaveResult(status: RaveStatus.cancelled);
  }

  ThemeData _getDefaultTheme(BuildContext context) {
    // Primary and accent colors are from Flutterwave's logo color
    return Theme.of(context).copyWith(
      primaryColor: Colors.black,
      accentColor: MyColors.buttercup,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
    );
  }
}
