import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/rave_result.dart';
import 'package:rave_flutter/src/widgets/payment/rave_pay_widget.dart';

class RavePayManager {
  // TODO: Write documentation for this
  static Future<RaveResult> initialize({
    @required BuildContext context,
    @required RavePayInitializer initializer,
  }) async {
    assert(context != null);

    // Validate the initializer params
    var error = RaveUtils.validateInitializer(initializer);
    if (error != null) {
      return RaveResult(status: RaveStatus.error, rawResponse: {'error': error});
    }

    var response = await Navigator.of(context).push<RaveResult>(
      MaterialPageRoute<RaveResult>(
        builder: (context) => RavePayWidget(
              initializer: initializer,
            ),
      ),
    );

    // Return a cancelled response is null
    return response == null ? RaveResult(status: RaveStatus.cancelled) : response;
  }
}
