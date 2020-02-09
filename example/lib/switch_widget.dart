import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool value;
  final String title;
  final ValueChanged<bool> onChanged;

  SwitchWidget(
      {@required this.value, @required this.title, @required this.onChanged});

  @override
  Widget build(BuildContext context) => SwitchListTile.adaptive(
        value: value,
        title: Text(title),
        onChanged: onChanged,
      );
}
