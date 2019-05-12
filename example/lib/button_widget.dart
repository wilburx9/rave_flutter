import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  Button({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton.filled(
            child: Text(text),
            pressedOpacity: 0.5,
            onPressed: onPressed,
          )
        : RaisedButton(
            onPressed: onPressed,
            child: Text(text.toUpperCase()),
          );
  }
}
