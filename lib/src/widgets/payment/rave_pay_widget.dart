import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/widgets/base_widget.dart';
import 'package:rave_flutter/src/widgets/custom_dialog.dart';
import 'package:rave_flutter/src/widgets/payment/pages/account_payment_widget.dart';
import 'package:rave_flutter/src/widgets/payment/pages/ach_payment_widget.dart';
import 'package:rave_flutter/src/widgets/payment/pages/card_payment_widget.dart';
import 'package:rave_flutter/src/widgets/payment/pages/gh_mobile_money_payment_widget.dart';
import 'package:rave_flutter/src/widgets/payment/pages/mpesa_payment_widget.dart';
import 'package:rave_flutter/src/widgets/payment/pages/ug_mobile_money_payment_widget.dart';

class RavePayWidget extends StatefulWidget {
  final RavePayInitializer initializer;

  RavePayWidget({@required this.initializer});

  @override
  _RavePayWidgetState createState() => _RavePayWidgetState(initializer);
}

class _RavePayWidgetState extends BaseState<RavePayWidget> with TickerProviderStateMixin {
  final RavePayInitializer initializer;
  AnimationController _animationController;
  Animation _animation;
  var slideUpTween = Tween<Offset>(begin: Offset(0, 0.4), end: Offset.zero);
  var slideRightTween = Tween<Offset>(begin: Offset(-0.4, 0), end: Offset.zero);
  int selectedIndex;
  List<_Item> _items;

  _RavePayWidgetState(this.initializer);

  @override
  void initState() {
    _items = _getItems();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
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
  Widget buildChild(BuildContext context) {
    // TODO: Handle empty pages ie when all payment methods are disabled
    // TODO: Check for phone state permission
    return CustomAlertDialog(
      fullscreen: initializer.fullScreen,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: _buildHeader(),
      expanded: true,
      onCancelPress: onCancelPress,
      content: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
        child: FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: slideUpTween.animate(_animation),
            child: SingleChildScrollView(
              child: Column(
                children: _items.map((item) {
                  var index = _items.indexOf(item);
                  return AnimatedSize(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    alignment: Alignment.topCenter,
                    vsync: this,
                    child: selectedIndex == index ? item.content : buildItemHeader(index),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    var rightWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        initializer.email != null
            ? Text(
                initializer.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700], fontSize: 12.0),
              )
            : SizedBox(),
        initializer.amount == null || initializer.amount.isNegative
            ? SizedBox()
            : RichText(
                text: TextSpan(
                    text: '${initializer.currency} ',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: RaveUtils.formatAmount(
                          initializer.amount,
                        ),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ]),
              ),
      ],
    );

    var rightText = Text(
      initializer.companyName ?? initializer.staging ? Strings.demo : '',
      maxLines: 1,
      style: TextStyle(color: Colors.grey[800], fontSize: 16),
    );

    Widget header = AnimatedPadding(
      padding: EdgeInsets.symmetric(vertical: selectedIndex == null ? 20 : 10),
      duration: Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 40, height: 40),
            child: initializer.companyLogo ??
                SvgPicture.asset('assets/images/flutterwave_logo.svg',
                    package: 'rave_flutter'),
          ),
          SizedBox(
            width: 50.0,
          ),
          Flexible(
              child: AnimatedSize(
                  child: selectedIndex == null ? rightWidget : rightText,
                  vsync: this,
                  duration: Duration(milliseconds: 2000))),
        ],
      ),
    );

    if (selectedIndex == null) {
      header = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          header,
          SlideTransition(
            position: slideRightTween.animate(_animation),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'How would \nyou like to pay?',
                  style: TextStyle(
                      color: Colors.grey[900], fontWeight: FontWeight.w400, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: MyColors.buttercup,
                  ),
                )
              ],
            ),
          )
        ],
      );
    }
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: header,
      ),
    );
  }

  List<_Item> _getItems() {
    var items = <_Item>[];
    if (initializer.acceptCardPayments) {
      items.add(_Item(Strings.card, 'card', CardPaymentWidget(initializer)));
    }

    if (initializer.acceptAccountPayments) {
      if (initializer.country.toLowerCase() == 'us' &&
          initializer.currency.toLowerCase() == 'usd') {
        items.add(_Item(Strings.ach, 'note', AchPaymentWidget(initializer)));
      } else {
        items.add(_Item(Strings.account, 'bank', AccountPaymentWidget(initializer)));
      }
    }

    if (initializer.acceptMpesaPayments) {
      items.add(_Item(Strings.mpesa, 'note', MpesaPaymentWidget(initializer)));
    }

    if (initializer.acceptGHMobileMoneyPayments) {
      items.add(_Item(
          Strings.ghanaMobileMoney, 'note', GhMobileMoneyPaymentWidget(initializer)));
    }

    if (initializer.acceptUgMobileMoneyPayments) {
      items.add(_Item(
          Strings.ugandaMobileMoney, 'note', UgMobileMoneyPaymentWidget(initializer)));
    }
    return items;
  }

  Widget buildItemHeader(int index) {
    var item = _items[index];
    var border = BorderSide(color: Colors.grey, width: 0.5);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(border: Border(top: border, bottom: border)),
      child: FlatButton(
        color: Colors.grey[100],
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/${item.icon}.svg',
              width: 24,
              package: 'rave_flutter',
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(child: Text('Pay with ${item.title}')),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _Item {
  final Widget content;
  final String title;
  final String icon;

  _Item(this.title, this.icon, this.content);
}
