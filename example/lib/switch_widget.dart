import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool value;
  final String title;
  final ValueChanged<bool> onChanged;

  SwitchWidget(
      {@required this.value, @required this.title, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    var tileWidget = Text(title);
    return Platform.isIOS
        ? ListTile(
            leading: tileWidget,
            trailing: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).accentColor,
            ),
          )
        : SwitchListTile.adaptive(
            value: value, title: tileWidget, onChanged: onChanged);
  }
}
