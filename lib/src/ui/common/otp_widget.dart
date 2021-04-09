import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class OtpWidget extends StatefulWidget {
  final String? message;
  final ValueChanged<String?>? onPinInputted;

  OtpWidget({required this.message, required this.onPinInputted});

  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  var _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  String? _otp;
  var heightBox = SizedBox(height: 20.0);

  @override
  Widget build(BuildContext context) {
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
              autoFocus: true,
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
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: FlatButton(
                color: MyColors.buttercup,
                child: Text(
                  "Continue",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 20,
                ),
                onPressed: _validateInputs,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      form.save();
      widget.onPinInputted!(_otp);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
