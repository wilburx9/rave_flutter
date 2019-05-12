import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/payload.dart';

abstract class BasePaymentPage extends StatefulWidget {
  final RavePayInitializer initializer;

  BasePaymentPage(this.initializer);
}

abstract class BasePaymentPageState<T extends BasePaymentPage> extends State<T>
    with SingleTickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();
  AnimationController _animationController;
  Animation _animation;
  var slideInTween = Tween<Offset>(begin: Offset(0, -0.1), end: Offset.zero);
  bool autoValidate = false;
  var payload = Payload.empty();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
      opacity: _animation,
      child: SlideTransition(
        position: slideInTween.animate(_animation),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Form(
              key: formKey,
              autovalidate: autoValidate,
              child: Column(
                children: buildFormChildren()
                  ..add(
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: validateInputs,
                        color: Theme.of(context).buttonTheme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(Strings.pay),
                      ),
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildFormChildren();

  validateInputs() {
    var formState = formKey.currentState;
    if (!formState.validate()) {
      setState(() => autoValidate = true);
      return;
    }

    formState.save();
    onFormValidated();
  }

  onFormValidated();
}
