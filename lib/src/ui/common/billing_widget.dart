import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class BillingWidget extends StatefulWidget {
  final ValueChanged<Map<String, String?>>? onBillingInputted;

  BillingWidget({required this.onBillingInputted});

  @override
  _BillingWidgetState createState() => _BillingWidgetState();
}

class _BillingWidgetState extends State<BillingWidget> {
  var _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? country;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          children: <Widget>[
            Text(
              "Enter your billing address details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            BaseTextField(
              keyboardType: TextInputType.text,
              autoFocus: true,
              validator: _validate,
              onSaved: (value) => address = value,
              hintText: "Address e.g 20 Saltlake Eldorado",
            ),
            SizedBox(height: 10),
            BaseTextField(
              keyboardType: TextInputType.text,
              validator: _validate,
              onSaved: (value) => city = value,
              hintText: "City e.g. Livingstone",
            ),
            SizedBox(height: 10),
            BaseTextField(
              keyboardType: TextInputType.text,
              validator: _validate,
              onSaved: (value) => state = value,
              hintText: "State e.g. CA",
            ),
            SizedBox(height: 10),
            BaseTextField(
              keyboardType: TextInputType.text,
              validator: _validate,
              onSaved: (value) => zip = value,
              hintText: "Zip code e.g. 928302",
            ),
            SizedBox(height: 10),
            BaseTextField(
              keyboardType: TextInputType.text,
              validator: _validate,
              onSaved: (value) => country = value,
              hintText: "Country e.g. US",
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
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
      widget.onBillingInputted!({
        "address": address,
        "city": city,
        "state": state,
        "zip": zip,
        "counntry": country
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String? _validate(String? value) =>
      value == null || value.trim().isEmpty ? "Field is required" : null;
}
