import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/manager/account_transaction_manager.dart';
import 'package:rave_flutter/src/manager/ach_transaction_manager.dart';
import 'package:rave_flutter/src/manager/card_transaction_manager.dart';
import 'package:rave_flutter/src/manager/gh_mm_transaction_manager.dart';
import 'package:rave_flutter/src/manager/mpesa_transaction_manager.dart';
import 'package:rave_flutter/src/manager/ug_mm_transaction_manager.dart';
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

  @override
  void initState() {
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
      fullscreen: false,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: _buildHeader(),
      expanded: true,
      content: child,
    );
  }

  Widget _buildHeader() {
    var displayEmail = _initializer.displayEmail && _initializer.email != null;
    var displayAmount = _initializer.displayAmount &&
        (_initializer.amount != null || !_initializer.amount.isNegative);

    var rightWidget = displayEmail || displayAmount
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (displayEmail)
                Text(
                  _initializer.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12.0),
                ),
              if (displayAmount)
                RichText(
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
          )
        : null;

    var rightStr =
        _initializer.companyName ?? _initializer.staging ? Strings.demo : '';
    var rightText = Text(
      rightStr,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: onCancelPress,
                  color: Colors.red,
                ),
                AnimatedSize(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: _selectedIndex == null
                          ? rightWidget ?? rightText
                          : rightText,
                    ),
                    vsync: this,
                    duration: Duration(milliseconds: 800)),
              ],
            ),
          ),
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
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10, top: 5),
        child: header,
      ),
    );
  }

  List<_Item> _getItems() {
    var items = <_Item>[];
    if (_initializer.acceptCardPayments) {
      items.add(
        _Item(
          Strings.card,
          'card',
          CardPaymentWidget(
            manager: CardTransactionManager(
              context: context,
              onTransactionComplete: _onTransactionComplete,
            ),
          ),
        ),
      );
    }

    if (_initializer.acceptAccountPayments) {
      if (_initializer.country.toLowerCase() == 'us' &&
          _initializer.currency.toLowerCase() == 'usd') {
        items.add(_Item(
            Strings.ach,
            'note',
            AchPaymentWidget(
              manager: AchTransactionManager(
                  context: context,
                  onTransactionComplete: _onTransactionComplete),
            )));
      } else {
        items.add(
          _Item(
            Strings.account,
            'bank',
            AccountPaymentWidget(
              manager: AccountTransactionManager(
                  context: context,
                  onTransactionComplete: _onTransactionComplete),
            ),
          ),
        );
      }
    }

    if (_initializer.acceptMpesaPayments) {
      items.add(
        _Item(
          Strings.mpesa,
          'note',
          MpesaPaymentWidget(
            manager: MpesaTransactionManager(
                context: context,
                onTransactionComplete: _onTransactionComplete),
          ),
        ),
      );
    }

    if (_initializer.acceptGHMobileMoneyPayments) {
      items.add(
        _Item(
          Strings.ghanaMobileMoney,
          'note',
          GhMobileMoneyPaymentWidget(
            manager: GhMMTransactionManager(
                context: context,
                onTransactionComplete: _onTransactionComplete),
          ),
        ),
      );
    }

    if (_initializer.acceptUgMobileMoneyPayments) {
      items.add(
        _Item(
          Strings.ugandaMobileMoney,
          'note',
          UgMobileMoneyPaymentWidget(
            manager: UgMMTransactionManager(
                context: context,
                onTransactionComplete: _onTransactionComplete),
          ),
        ),
      );
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
