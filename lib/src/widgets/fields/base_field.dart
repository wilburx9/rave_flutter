import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/src/common/my_colors.dart';

class BaseTextField extends TextFormField {
  BaseTextField({
    Widget suffixIcon,
    Widget prefix,
    String labelText,
    String hintText,
    TextStyle prefixStyle,
    TextInputType keyboardType = TextInputType.number,
    List<TextInputFormatter> inputFormatters,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    TextEditingController controller,
    String initialValue,
  }) : super(
            controller: controller,
            inputFormatters: inputFormatters,
            onSaved: onSaved,
            validator: validator,
            maxLines: 1,
            initialValue: initialValue,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                hintStyle: TextStyle(
                    color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w500),
                suffixIcon: suffixIcon == null
                    ? null
                    : Padding(
                        padding: EdgeInsetsDirectional.only(end: 12),
                        child: suffixIcon,
                      ),
                hasFloatingPlaceholder: false,
                prefix: prefix,
                fillColor: Colors.grey[50],
                filled: true,
                prefixStyle: prefixStyle,
                errorStyle: TextStyle(fontSize: 12),
                errorMaxLines: 3,
                isDense: true,
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.buttercup, width: 1.5),
                    borderRadius: radius),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.buttercup, width: 1),
                    borderRadius: radius),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400].withOpacity(.7), width: .5),
                    borderRadius: radius),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400].withOpacity(.7), width: 1),
                    borderRadius: radius),
                hintText: hintText));

  @override
  createState() {
    return super.createState();
  }
}

const radius = BorderRadius.all(Radius.circular(1.5));
