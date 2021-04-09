import 'package:flutter/material.dart' hide ConnectionState;
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/common/validator_utills.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/manager/base_transaction_manager.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/ui/fields/amount_field.dart';
import 'package:rave_flutter/src/ui/fields/email_field.dart';

abstract class BasePaymentPage extends StatefulWidget {
  final BaseTransactionManager transactionManager;

  BasePaymentPage({required this.transactionManager});
}

abstract class BasePaymentPageState<T extends BasePaymentPage> extends State<T>
    with TickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();
  final initializer = Repository.instance.initializer;
  final _connectionBloc = ConnectionBloc.instance;
  TextEditingController? _amountController;
  TextEditingController? _emailController;
  late AnimationController _animationController;
  AnimationController? _infoAnimationController;
  late Animation _infoAnimation;
  var _emailFocusNode = FocusNode();
  var _amountFocusNode = FocusNode();
  late Animation _animation;
  var _slideInTween = Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero);
  bool _autoValidate = false;
  Payload? payload;

  bool _cameWithValidAmount = true;
  bool _cameWithValidEmail = true;
  int _infoAnimationRepetition = 0;

  @override
  void initState() {
    payload = Payload.fromInitializer(initializer);
    if (!ValidatorUtils.isAmountValid(initializer.amount.toString())) {
      _cameWithValidAmount = false;
      _amountController = TextEditingController();
      _amountController!.addListener(_updateAmount);
    }

    if (!ValidatorUtils.isEmailValid(initializer.email)) {
      _cameWithValidEmail = false;
      _emailController = TextEditingController();
      _emailController!.addListener(_updateEmail);
    }
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(
        parent: Tween<double>(begin: 0, end: 1).animate(_animationController),
        curve: Curves.fastOutSlowIn);
    _animationController.forward();

    if (!supported) {
      _infoAnimationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 400));
      _infoAnimation = Tween<double>(begin: 1.0, end: 1.2)
          .animate(_infoAnimationController!);
      _infoAnimationController!.addStatusListener(_onInfoAnimationChange);
    }
    super.initState();
  }

  @override
  void dispose() {
    _amountController?.dispose();
    _emailController?.dispose();
    _animationController.dispose();
    _emailFocusNode.dispose();
    _amountFocusNode.dispose();
    _infoAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = buildWidget(context);
    return FadeTransition(
      opacity: _animation as Animation<double>,
      child: SlideTransition(
        position: _slideInTween.animate(_animation as Animation<double>),
        child: SingleChildScrollView(
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: MyColors.buttercup.withOpacity(.09)),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder<ConnectionState>(
                  stream: ConnectionBloc.instance.stream,
                  builder: (context, snapshot) {
                    return snapshot.hasData &&
                            snapshot.data == ConnectionState.waiting
                        ? IgnorePointer(
                            child: child,
                          )
                        : child;
                  },
                )),
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
              focusNode: _amountFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => swapFocus(_amountFocusNode,
                  showEmailField() ? _emailFocusNode : getNextFocusNode()),
              currency: initializer.currency,
              controller: _amountController,
              onSaved: (value) => payload!.amount = value!,
            ),
      _cameWithValidEmail || !showEmailField()
          ? SizedBox()
          : EmailField(
              focusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) =>
                  swapFocus(_emailFocusNode, getNextFocusNode()),
              controller: _emailController,
              onSaved: (value) => payload!.email = value)
    ];

    var payButton = Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20, bottom: 15),
      child: FlatButton(
        onPressed: _validateInputs,
        color: MyColors.buttercup,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                child: Text(
                  getPaymentText()!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15),
                ),
                alignment: Alignment.center,
              ),
            ),
            Icon(Icons.keyboard_arrow_right, color: Colors.white)
          ],
        ),
      ),
    );

    Widget topWidget = buildTopWidget();

    Widget info = supported
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: 15),
            child: ScaleTransition(
              scale: _infoAnimation as Animation<double>,
              child: Text(
                "This payment mode is currently under development",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          );

    return Form(
      key: formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: amountAndEmailFields
          ..insert(0, topWidget)
          ..addAll(buildLocalFields(data))
          ..add(info)
          ..add(payButton),
      ),
    );
  }

  Widget buildHeader() {
    var emailText = Text(
      initializer.email!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w600),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (initializer.displayAmount &&
              ValidatorUtils.isAmountValid(initializer.amount.toString()))
            Flexible(
                child: RichText(
              text: TextSpan(
                text: '${initializer.currency} '.toUpperCase(),
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600),
                children: <TextSpan>[
                  TextSpan(
                    text: formatAmount(
                      initializer.amount,
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )),
          SizedBox(width: 20),
          initializer.displayEmail && showEmailField()
              ? Flexible(child: emailText)
              : SizedBox()
        ],
      ),
    );
  }

  swapFocus(FocusNode oldFocus, [FocusNode? newFocus]) {
    oldFocus.unfocus();
    if (newFocus != null) {
      FocusScope.of(context).requestFocus(newFocus);
    } else {
      // The user has reached the end of the form
      _validateInputs();
    }
  }

  bool showEmailField() => true;

  List<Widget> buildLocalFields([data]);

  String? getPaymentText() {
    if (initializer.payButtonText != null &&
        initializer.payButtonText!.isNotEmpty) {
      return initializer.payButtonText;
    }
    if (initializer.amount.isNegative) {
      return Strings.pay;
    }

    return '${Strings.pay} ${initializer.currency.toUpperCase()} ${formatAmount(initializer.amount)}';
  }

  _validateInputs() {
    var formState = formKey.currentState!;
    if (!formState.validate()) {
      setState(() => _autoValidate = true);
      return;
    }

    formState.save();
    FocusScope.of(context).unfocus();
    onFormValidated();
  }

  @mustCallSuper
  onFormValidated() {
    if (!supported) {
      _blinkInfoWidget();
      return;
    }
    widget.transactionManager.processTransaction(payload);
  }

  void _updateAmount() => setState(
      () => initializer.amount = double.tryParse(_amountController!.text) ?? 0);

  void _updateEmail() =>
      setState(() => initializer.email = _emailController!.text);

  Widget buildWidget(BuildContext context) => Column(
        children: <Widget>[
          buildHeader(),
          buildMainFields(),
        ],
      );

  FocusNode? getNextFocusNode();

  Widget buildTopWidget() => SizedBox();

  bool get autoValidate => _autoValidate;

  bool get supported => true;

  setDataState(ConnectionState state) => _connectionBloc.setState(state);

  _blinkInfoWidget() {
    if (_infoAnimationController!.isAnimating) return;
    _infoAnimationController!.forward();
  }

  _onInfoAnimationChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _infoAnimationController!.reverse();
    } else if (status == AnimationStatus.dismissed) {
      if (_infoAnimationRepetition >= 1) {
        _infoAnimationRepetition = 0;
      } else {
        _infoAnimationController!.forward();
        _infoAnimationRepetition++;
      }
    }
  }
}
