import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/ui/base_widget.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class OtpWidget extends StatefulWidget {
  final String message;
  final ValueChanged<String> onPinInputted;

  OtpWidget({@required this.message, @required this.onPinInputted});

  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends BaseState<OtpWidget> {
  var _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  String _otp;
  var heightBox = SizedBox(height: 20.0);

  @override
  void initState() {
    confirmationMessage = 'Do you want cancel OTP?';
    super.initState();
  }

  @override
  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            heightBox,
            Text(
              widget.message ?? "Enter your one  time password (OTP)",
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
              ],
              obscureText: true,
              hintText: "OTP",
              onSaved: (value) => _otp = value,
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Field is required"
                  : null,
            ),
            FlatButton(
              color: Colors.grey[100],
              child: Text("Continue"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              padding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
              onPressed: _validateInputs,
            )
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      form.save();
      widget.onPinInputted(_otp);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
