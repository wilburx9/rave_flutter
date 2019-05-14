import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/rave_flutter.dart';

class AddVendorWidget extends StatefulWidget {
  @override
  _AddVendorWidgetState createState() => _AddVendorWidgetState();
}

class _AddVendorWidgetState extends State<AddVendorWidget> {
  var formKey = GlobalKey<FormState>();
  var refFocusNode = FocusNode();
  var ratioFocusNode = FocusNode();
  bool autoValidate = false;
  String id;
  String ratio;

  @override
  void dispose() {
    refFocusNode.dispose();
    ratioFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        autovalidate: autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration:
                  InputDecoration(hintText: 'Your Vendor\'s Rave Reference'),
              onSaved: (value) => id = value,
              textCapitalization: TextCapitalization.words,
              focusNode: refFocusNode,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                refFocusNode.unfocus();
                FocusScope.of(context).requestFocus(ratioFocusNode);
              },
              validator: (value) =>
                  value.trim().isEmpty ? 'Field is required' : null,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Ratio for this vendor'),
              onSaved: (value) => ratio = value,
              keyboardType: TextInputType.number,
              focusNode: ratioFocusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                ratioFocusNode.unfocus();
                validateInputs();
              },
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              validator: (value) =>
                  value.trim().isEmpty ? 'Field is required' : null,
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL')),
        FlatButton(onPressed: validateInputs, child: Text('ADD')),
      ],
    );
  }

  void validateInputs() {
    var formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      Navigator.of(context).pop(SubAccount(id, ratio));
    } else {
      setState(() => autoValidate = true);
    }
  }
}
