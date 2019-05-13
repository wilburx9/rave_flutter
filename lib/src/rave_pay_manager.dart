import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/rave_result.dart';
import 'package:rave_flutter/src/widgets/payment/rave_pay_widget.dart';

class RavePayManager {
  RavePayManager._internal();

  static final RavePayManager _manager = RavePayManager._internal();

  factory RavePayManager() {
    return _manager;
  }

  // TODO: Write documentation for this
  Future<RaveResult> initialize({
    @required BuildContext context,
    @required RavePayInitializer initializer,
    ThemeData themeData,
  }) async {
    assert(context != null);
    assert(initializer != null);

    // Validate the initializer params
    var error = ValidatorUtils.validateInitializer(initializer);
    if (error != null) {
      return RaveResult(status: RaveStatus.error, rawResponse: {'error': error});
    }

    var result = showDialog<RaveResult>(
        context: context,
        barrierDismissible: false,
        builder: (_) => Theme(
              data: themeData ?? _getDefaultTheme(context),
              child: RavePayWidget(
                initializer: initializer,
              ),
            ));

    // Return a cancelled response is null
    return result == null ? RaveResult(status: RaveStatus.cancelled) : result;
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
