import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/ui/base_widget.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class PinWidget extends StatefulWidget {
  final ValueChanged<String> onPinInputted;

  PinWidget({@required this.onPinInputted});

  @override
  _PinWidgetState createState() => _PinWidgetState();
}

class _PinWidgetState extends BaseState<PinWidget> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    confirmationMessage = 'Do you want cancel PIN?';
    _controller.addListener(_onChange);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    var heightBox = SizedBox(height: 20);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // buildStar(),
          heightBox,
          Text(
            "Please enter your card pin to continue your transaction",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontSize: 15.0,
            ),
          ),
          heightBox,
          BaseTextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 25.0,
              letterSpacing: 15.0,
            ),
            autofocus: true,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            obscureText: true,
            controller: _controller,
            hintText: "PIN",
          ),
        ],
      ),
    );
  }

  void _onChange() {
    var value = _controller.text;
    if (value.length == 4) {
      widget.onPinInputted(value);
    }
  }
}
