import 'package:flutter/material.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';

class BillingWidget extends StatefulWidget {
  final ValueChanged<Map<String, String>> onBillingInputted;

  BillingWidget({@required this.onBillingInputted});

  @override
  _BillingWidgetState createState() => _BillingWidgetState();
}

class _BillingWidgetState extends State<BillingWidget> {
  var _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  String address;
  String city;
  String state;
  String zip;
  String country;

  @override
  Widget build(BuildContext context) {
    return Form(
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
            autofocus: true,
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
          SizedBox(height: 20),
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
    );
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      form.save();
      widget.onBillingInputted({
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

  String _validate(String value) =>
      value == null || value.trim().isEmpty ? "Field is required" : null;
}
