import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rave_flutter/rave_flutter.dart';

import 'button_widget.dart';
import 'switch_widget.dart';
import 'vendor_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.pink),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  bool acceptCardPayment = true;
  bool acceptAccountPayment = true;
  bool acceptMpesaPayment = false;
  bool shouldDisplayFee = true;
  bool acceptAchPayments = false;
  bool acceptGhMMPayments = false;
  bool acceptUgMMPayments = false;
  bool acceptMMFrancophonePayments = false;
  bool live = false;
  bool preAuthCharge = false;
  bool addSubAccounts = false;
  List<SubAccount> subAccounts = [];
  String email;
  double amount;
  String publicKey = "PASTE PUBLIC KEY HERE";
  String encryptionKey = "PASTE ENCRYPTION KEY HERE";
  String txRef;
  String orderRef;
  String narration;
  String currency;
  String country;
  String firstName;
  String lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                SwitchWidget(
                  value: acceptCardPayment,
                  title: 'Accept card payments',
                  onChanged: (value) =>
                      setState(() => acceptCardPayment = value),
                ),
                SwitchWidget(
                  value: acceptAccountPayment,
                  title: 'Accept account payments',
                  onChanged: (value) =>
                      setState(() => acceptAccountPayment = value),
                ),
                SwitchWidget(
                  value: acceptMpesaPayment,
                  title: 'Accept Mpesa payments',
                  onChanged: (value) =>
                      setState(() => acceptMpesaPayment = value),
                ),
                SwitchWidget(
                  value: shouldDisplayFee,
                  title: 'Should Display Fee',
                  onChanged: (value) =>
                      setState(() => shouldDisplayFee = value),
                ),
                SwitchWidget(
                  value: acceptAchPayments,
                  title: 'Accept ACH payments',
                  onChanged: (value) =>
                      setState(() => acceptAchPayments = value),
                ),
                SwitchWidget(
                  value: acceptGhMMPayments,
                  title: 'Accept GH Mobile money payments',
                  onChanged: (value) =>
                      setState(() => acceptGhMMPayments = value),
                ),
                SwitchWidget(
                  value: acceptUgMMPayments,
                  title: 'Accept UG Mobile money payments',
                  onChanged: (value) =>
                      setState(() => acceptUgMMPayments = value),
                ),
                SwitchWidget(
                  value: acceptMMFrancophonePayments,
                  title: 'Accept Mobile money Francophone Africa payments',
                  onChanged: (value) =>
                      setState(() => acceptMMFrancophonePayments = value),
                ),
                SwitchWidget(
                  value: live,
                  title: 'Live',
                  onChanged: (value) => setState(() => live = value),
                ),
                SwitchWidget(
                  value: preAuthCharge,
                  title: 'Pre Auth Charge',
                  onChanged: (value) => setState(() => preAuthCharge = value),
                ),
                SwitchWidget(
                    value: addSubAccounts,
                    title: 'Add subaccounts',
                    onChanged: onAddAccountsChange),
                buildVendorRefs(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: formKey,
                    autovalidateMode: autoValidate,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Email'),
                          onSaved: (value) => email = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Amount to charge'),
                          onSaved: (value) => amount = double.tryParse(value),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'txRef'),
                          onSaved: (value) => txRef = value,
                          initialValue:
                              "rave_flutter-${DateTime.now().toString()}",
                          validator: (value) =>
                              value.trim().isEmpty ? 'Field is required' : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'orderRef'),
                          onSaved: (value) => orderRef = value,
                          initialValue:
                              "rave_flutter-${DateTime.now().toString()}",
                          validator: (value) =>
                              value.trim().isEmpty ? 'Field is required' : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Narration'),
                          onSaved: (value) => narration = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Currency code e.g NGN'),
                          onSaved: (value) => currency = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Country code e.g NG'),
                          onSaved: (value) => country = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'First name'),
                          onSaved: (value) => firstName = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Last name'),
                          onSaved: (value) => lastName = value,
                        ),
                      ],
                    ),
                  ),
                ),
                Button(text: 'Start Payment', onPressed: validateInputs)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildVendorRefs() {
    if (!addSubAccounts) {
      return SizedBox();
    }

    addSubAccount() async {
      var subAccount = await showDialog<SubAccount>(
          context: context, builder: (context) => AddVendorWidget());
      if (subAccount != null) {
        if (subAccounts == null) subAccounts = [];
        setState(() => subAccounts.add(subAccount));
      }
    }

    var buttons = <Widget>[
      Button(
        onPressed: addSubAccount,
        text: 'Add vendor',
      ),
      SizedBox(
        width: 10,
        height: 10,
      ),
      Button(
        onPressed: () => onAddAccountsChange(false),
        text: 'Clear',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your current vendor refs are: ${subAccounts.map((a) => '${a.id}(${a.transactionSplitRatio})').join(', ')}',
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Platform.isIOS
                ? Column(
                    children: buttons,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buttons,
                  ),
          )
        ],
      ),
    );
  }

  onAddAccountsChange(bool value) {
    setState(() {
      addSubAccounts = value;
      if (!value) {
        subAccounts.clear();
      }
    });
  }

  void validateInputs() {
    var formState = formKey.currentState;
    if (!formState.validate()) {
      setState(() => autoValidate = AutovalidateMode.always);
      return;
    }

    formState.save();
    startPayment();
  }

  void startPayment() async {
    var initializer = RavePayInitializer(
        amount: amount,
        publicKey: publicKey,
        encryptionKey: encryptionKey,
        subAccounts: subAccounts.isEmpty ? null : subAccounts,
        txRef: txRef)
      ..country =
          country = country != null && country.isNotEmpty ? country : "NG"
      ..currency = currency != null && currency.isNotEmpty ? currency : "NGN"
      ..email = email
      ..fName = firstName
      ..lName = lastName
      ..narration = narration ?? ''
      ..orderRef = orderRef
      ..acceptMpesaPayments = acceptMpesaPayment
      ..acceptAccountPayments = acceptAccountPayment
      ..acceptCardPayments = acceptCardPayment
      ..acceptAchPayments = acceptAchPayments
      ..acceptGHMobileMoneyPayments = acceptGhMMPayments
      ..acceptUgMobileMoneyPayments = acceptUgMMPayments
      ..acceptMobileMoneyFrancophoneAfricaPayments = acceptMMFrancophonePayments
      ..displayEmail = false
      ..displayAmount = false
      ..staging = !live
      ..isPreAuth = preAuthCharge
      ..displayFee = shouldDisplayFee;

    var response = await RavePayManager()
        .prompt(context: context, initializer: initializer);
    print(response);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response?.message)));
  }
}
