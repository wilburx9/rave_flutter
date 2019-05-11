import 'package:flutter/material.dart';

abstract class BasePaymentPage extends StatefulWidget {}

abstract class BasePaymentPageState<T extends BasePaymentPage> extends State
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  var slideInTween = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero);

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _animation = CurvedAnimation(
        parent: Tween<double>(begin: 0, end: 1).animate(_animationController),
        curve: Curves.fastOutSlowIn);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation.value,
      child: SlideTransition(
        position: slideInTween.animate(_animation),
        child: buildPage(context),
      ),
    );
  }

  Widget buildPage(BuildContext context);
}
