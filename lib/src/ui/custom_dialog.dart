import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// This is a modification of [AlertDialog]. A lot of modifications was made. The goal is
/// to retain the dialog feel and look while adding the close IconButton
class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    this.title,
    this.titlePadding,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10),
    this.expanded = false,
    this.fullscreen = false,
    this.borderRadius = const BorderRadius.only(
        topLeft: _defaultRadiusLarge,
        topRight: _defaultRadiusLarge,
        bottomRight: _defaultRadiusSmall,
        bottomLeft: _defaultRadiusSmall),
    required this.content,
  })  : assert(content != null),
        super(key: key);

  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final bool expanded;
  final bool fullscreen;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (title != null && titlePadding != null) {
      children.add(Padding(
        padding: titlePadding!,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline6!,
          child: Semantics(child: title, namesRoute: true),
        ),
      ));
    }

    children.add(Flexible(
      child: Padding(
        padding: contentPadding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: content,
        ),
      ),
    ));

    return buildContent(children);
  }

  Widget buildContent(List<Widget> children) {
    Widget widget;
    if (fullscreen) {
      widget = Material(
        color: Colors.white,
        child: Container(
            child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: children),
        )),
      );
    } else {
      var body = Material(
        type: MaterialType.card,
        borderRadius: borderRadius,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
      var child = IntrinsicWidth(
        child: body,
      );
      widget = CustomDialog(child: child, expanded: expanded);
    }
    return widget;
  }
}

/// This is a modification of [Dialog]. The only modification is increasing the
/// elevation and changing the Material type.
class CustomDialog extends StatelessWidget {
  CustomDialog({
    Key? key,
    required this.child,
    required this.expanded,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final Widget child;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: expanded
                    ? math.min((MediaQuery.of(context).size.width - 40), 400)
                    : 280.0),
            child: Material(
              elevation: 50.0,
              type: MaterialType.transparency,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

const _defaultRadiusLarge = Radius.circular(10);
const _defaultRadiusSmall = Radius.circular(2);
