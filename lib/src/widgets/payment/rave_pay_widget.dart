import 'package:flutter/material.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/widgets/payment/pages/account_payment_widget.dart';
import 'package:rave_flutter/src/widgets/payment/pages/ach_payment_widget.dart';
import 'package:rave_flutter/src/widgets/payment/pages/base_payment_page.dart';
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

class _RavePayWidgetState extends State<RavePayWidget>
    with SingleTickerProviderStateMixin {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final RavePayInitializer initializer;
  TabController _controller;
  List<_Page> _pages;

  _RavePayWidgetState(this.initializer);

  @override
  void initState() {
    _pages = _getPages();
    _controller = TabController(length: _pages.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Handle empty pages ie when all payment methods are disabled
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).padding.top,
          color: Theme.of(context).primaryColor,
        ),
        Expanded(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: TabBar(
              controller: _controller,
              labelColor: Colors.grey[900],
              isScrollable: _pages.length >3,
              unselectedLabelColor: Colors.grey[600],
              tabs: _pages.map((page) => Tab(text: page.title.toUpperCase())).toList(),
            ),
            body: TabBarView(
              controller: _controller,
              children: _pages.map((page) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: Container(
                    key: ValueKey(page.title),
                    child: page.widget,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<_Page> _getPages() {
    var pages = <_Page>[];
    if (initializer.acceptCardPayments) {
      pages.add(_Page(Strings.card, CardPaymentWidget()));
    }

    if (initializer.acceptAccountPayments) {
      if (initializer.country.toLowerCase() == 'us' &&
          initializer.currency.toLowerCase() == 'usd') {
        pages.add(_Page(Strings.ach, AchPaymentWidget()));
      } else {
        pages.add(_Page(Strings.account, AccountPaymentWidget()));
      }
    }

    if (initializer.acceptMpesaPayments) {
      pages.add(_Page(Strings.mpesa, MpesaPaymentWidget()));
    }

    if (initializer.acceptGHMobileMoneyPayments) {
      pages.add(_Page(Strings.ghanaMobileMoney, GhMobileMoneyPaymentWidget()));
    }

    if (initializer.acceptUgMobileMoneyPayments) {
      pages.add(_Page(Strings.ugandaMobileMoney, UgMobileMoneyPaymentWidget()));
    }
    return pages;
  }
}

class _Page {
  String title;
  BasePaymentPage widget;

  _Page(this.title, this.widget);
}
