import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/manager/transaction_manager.dart';
import 'package:rave_flutter/src/rave_result.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/ui/base_widget.dart';
import 'package:rave_flutter/src/ui/common/billing_widget.dart';
import 'package:rave_flutter/src/ui/common/otp_widget.dart';
import 'package:rave_flutter/src/ui/common/overlay_loader.dart';
import 'package:rave_flutter/src/ui/common/pin_widget.dart';
import 'package:rave_flutter/src/ui/custom_dialog.dart';
import 'package:rave_flutter/src/ui/payment/pages/account_payment_widget.dart';
import 'package:rave_flutter/src/ui/payment/pages/ach_payment_widget.dart';
import 'package:rave_flutter/src/ui/payment/pages/card_payment_widget.dart';
import 'package:rave_flutter/src/ui/payment/pages/gh_mobile_money_payment_widget.dart';
import 'package:rave_flutter/src/ui/payment/pages/mpesa_payment_widget.dart';
import 'package:rave_flutter/src/ui/payment/pages/ug_mobile_money_payment_widget.dart';

class RavePayWidget extends StatefulWidget {
  @override
  _RavePayWidgetState createState() => _RavePayWidgetState();
}

class _RavePayWidgetState extends BaseState<RavePayWidget>
    with TickerProviderStateMixin {
  final RavePayInitializer _initializer = Repository.instance.initializer;
  AnimationController _animationController;
  Animation _animation;
  var _slideUpTween = Tween<Offset>(begin: Offset(0, 0.4), end: Offset.zero);
  var _slideRightTween =
      Tween<Offset>(begin: Offset(-0.4, 0), end: Offset.zero);
  int _selectedIndex;
  List<_Item> _items;
  TransactionManager _transactionManager;

  @override
  void initState() {
    _transactionManager = TransactionManager(
        context: context, onTransactionComplete: _onTransactionComplete);
    _items = _getItems();
    if (_items.length == 1) {
      _selectedIndex = 0;
    }
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
    ConnectionBloc.instance.dispose();
    TransactionBloc.instance.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    var column = Column(
      children: _items.map((item) {
        var index = _items.indexOf(item);
        return _selectedIndex == index ? item.content : buildItemHeader(index);
      }).toList(),
    );
    Widget child = SingleChildScrollView(
      child: AnimatedSize(
        duration: Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        alignment: Alignment.topCenter,
        vsync: this,
        child: StreamBuilder<TransactionState>(
          stream: TransactionBloc.instance.stream,
          builder: (_, snapshot) {
            var transactionState = snapshot.data;
            Widget w;
            if (!snapshot.hasData) {
              w = column;
            } else {
              switch (transactionState.state) {
                case State.initial:
                  w = column;
                  break;
                case State.pin:
                  w = PinWidget(
                    onPinInputted: transactionState.callback,
                  );
                  break;
                case State.otp:
                  w = OtpWidget(
                    onPinInputted: transactionState.callback,
                    message: transactionState.data,
                  );
                  break;
                case State.avsSecure:
                  w = BillingWidget(
                      onBillingInputted: transactionState.callback);
              }
            }
            return w;
          },
        ),
      ),
    );
    var dataStreamBuilder = StreamBuilder<ConnectionState>(
      stream: ConnectionBloc.instance.stream,
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot.data == ConnectionState.waiting
            ? OverlayLoaderWidget()
            : SizedBox();
      },
    );
    child = AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
      child: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: _slideUpTween.animate(_animation),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Positioned(
                child: child,
              ),
              dataStreamBuilder
            ],
          ),
        ),
      ),
    );
    return CustomAlertDialog(
      fullscreen:false,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: _buildHeader(),
      expanded: true,
      content: child,
    );
  }

  Widget _buildHeader() {
    var rightWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _initializer.email != null
            ? Text(
                _initializer.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700], fontSize: 12.0),
              )
            : SizedBox(),
        _initializer.amount == null || _initializer.amount.isNegative
            ? SizedBox()
            : RichText(
                text: TextSpan(
                    text: '${_initializer.currency} '.toUpperCase(),
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: RaveUtils.formatAmount(
                          _initializer.amount,
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
      _initializer.companyName ?? _initializer.staging ? Strings.demo : '',
      maxLines: 1,
      style: TextStyle(color: Colors.grey[800], fontSize: 16),
    );

    Widget header = AnimatedPadding(
      padding: EdgeInsets.only(bottom: _selectedIndex == null ? 20 : 10),
      duration: Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 40, height: 40),
            child: _initializer.companyLogo ??
                SvgPicture.asset('assets/images/flutterwave_logo.svg',
                    package: 'rave_flutter'),
          ),
          SizedBox(
            width: 50.0,
          ),
          Flexible(
              child: AnimatedSize(
                  child: _selectedIndex == null ? rightWidget : rightText,
                  vsync: this,
                  duration: Duration(milliseconds: 2000))),
        ],
      ),
    );

    if (_selectedIndex == null) {
      header = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          header,
          SlideTransition(
            position: _slideRightTween.animate(_animation),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'How would \nyou like to pay?',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: onCancelPress,
            color: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: header,
          ),
        ],
      ),
    );
  }

  List<_Item> _getItems() {
    var items = <_Item>[];
    if (_initializer.acceptCardPayments) {
      items.add(_Item(
          Strings.card, 'card', CardPaymentWidget(t: _transactionManager)));
    }

    if (_initializer.acceptAccountPayments) {
      if (_initializer.country.toLowerCase() == 'us' &&
          _initializer.currency.toLowerCase() == 'usd') {
        items.add(_Item(Strings.ach, 'note', AchPaymentWidget()));
      } else {
        items.add(_Item(Strings.account, 'bank', AccountPaymentWidget()));
      }
    }

    if (_initializer.acceptMpesaPayments) {
      items.add(_Item(Strings.mpesa, 'note', MpesaPaymentWidget()));
    }

    if (_initializer.acceptGHMobileMoneyPayments) {
      items.add(_Item(
          Strings.ghanaMobileMoney, 'note', GhMobileMoneyPaymentWidget()));
    }

    if (_initializer.acceptUgMobileMoneyPayments) {
      items.add(_Item(
          Strings.ugandaMobileMoney, 'note', UgMobileMoneyPaymentWidget()));
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  @override
  getPopReturnValue() {
    return RaveResult(
        status: RaveStatus.cancelled, message: Strings.youCancelled);
  }

  _onTransactionComplete(RaveResult result) =>
      Navigator.of(context).pop(result);
}

class _Item {
  final Widget content;
  final String title;
  final String icon;

  _Item(this.title, this.icon, this.content);
}
