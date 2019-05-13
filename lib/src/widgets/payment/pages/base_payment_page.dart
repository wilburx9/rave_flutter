import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/payload.dart';
import 'package:rave_flutter/src/widgets/fields/amount_field.dart';
import 'package:rave_flutter/src/widgets/fields/email_field.dart';

abstract class BasePaymentPage extends StatefulWidget {
  final RavePayInitializer initializer;

  BasePaymentPage(this.initializer);
}

abstract class BasePaymentPageState<T extends BasePaymentPage> extends State<T>
    with TickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();
  TextEditingController _amountController;
  TextEditingController _emailController;
  AnimationController _animationController;
  Animation _animation;
  var _slideInTween = Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero);
  bool _autoValidate = false;
  var payload = Payload.empty();
  bool _cameWithValidAmount = true;
  bool _cameWithValidEmail = true;

  @override
  void initState() {
    if (!ValidatorUtils.isAmountValid(widget.initializer.amount.toString())) {
      _cameWithValidAmount = false;
      _amountController = TextEditingController();
      _amountController.addListener(_updateAmount);
    }

    if (!ValidatorUtils.isEmailValid(widget.initializer.email)) {
      _cameWithValidEmail = false;
      _emailController = TextEditingController();
      _emailController.addListener(_updateEmail);
    }
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
    _amountController?.dispose();
    _emailController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _slideInTween.animate(_animation),
        child: SingleChildScrollView(
          child: DecoratedBox(
            decoration: BoxDecoration(color: MyColors.buttercup.withOpacity(.09)),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: buildWidget(context)),
          ),
        ),
      ),
    );
  }

  Widget buildMainFields([data]) {
    var amountAndEmailFields = <Widget>[
      _cameWithValidAmount
          ? SizedBox()
          : AmountField(
              currency: widget.initializer.currency,
              controller: _amountController,
              onSaved: (value) => payload.amount = value,
            ),
      _cameWithValidEmail
          ? SizedBox()
          : EmailField(
              controller: _emailController, onSaved: (value) => payload.email = value)
    ];

    var payButton = Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      child: FlatButton(
        onPressed: validateInputs,
        color: MyColors.buttercup,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                child: AnimatedSize(
                  vsync: this,
                  alignment: Alignment.centerLeft,
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    getPaymentText(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),
            Icon(Icons.keyboard_arrow_right, color: Colors.white)
          ],
        ),
      ),
    );

    var creditsWidget = !showRaveCredits()
        ? SizedBox()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 25),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/rave.svg',
                  package: 'rave_flutter',
                ),
                Text(' by Flutterwave')
              ],
            ),
          );

    return Form(
      key: formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: amountAndEmailFields
          ..addAll(buildLocalFields(data))
          ..add(payButton)
          ..add(creditsWidget),
      ),
    );
  }

  Widget buildHeader() {
    var amountText = ValidatorUtils.isAmountValid(widget.initializer.amount.toString())
        ? Flexible(
            child: RichText(
            text: TextSpan(
                text: '${widget.initializer.currency} ',
                style: TextStyle(
                    fontSize: 10, color: Colors.grey[800], fontWeight: FontWeight.w600),
                children: <TextSpan>[
                  TextSpan(
                    text: RaveUtils.formatAmount(
                      widget.initializer.amount,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ]),
          ))
        : SizedBox();

    var emailText = Text(
      widget.initializer.email,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style:
          TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w600),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[amountText, SizedBox(width: 20), Flexible(child: emailText)],
      ),
    );
  }

  bool showRaveCredits() => false;

  List<Widget> buildLocalFields([data]);

  String getPaymentText() {
    if (widget.initializer.amount == null || widget.initializer.amount.isNegative) {
      return Strings.pay;
    }

    return '${Strings.pay} ${widget.initializer.currency}${RaveUtils.formatAmount(widget.initializer.amount)}';
  }

  validateInputs() {
    var formState = formKey.currentState;
    if (!formState.validate()) {
      setState(() => _autoValidate = true);
      return;
    }

    formState.save();
    onFormValidated();
  }

  onFormValidated();

  void _updateAmount() =>
      setState(() => widget.initializer.amount = double.tryParse(_amountController.text));

  void _updateEmail() => setState(() => widget.initializer.email = _emailController.text);

  Widget buildWidget(BuildContext context) => Column(
        children: <Widget>[buildHeader(), buildMainFields()],
      );
}
