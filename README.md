# Rave Flutter

[![build status](https://img.shields.io/github/workflow/status/wilburt/rave_flutter/Build%20and%20Test)](https://github.com/wilburt/rave_flutter/actions?query=Build+and+test)
[![Coverage Status](https://coveralls.io/repos/github/wilburt/rave_flutter/badge.svg?branch=master)](https://coveralls.io/github/wilburt/rave_flutter?branch=master)
[![pub package](https://img.shields.io/pub/v/rave_flutter.svg)](https://pub.dartlang.org/packages/rave_flutter)

<p>
    <img src="https://raw.githubusercontent.com/wilburt/rave_flutter/master/screenshots/payment_methods.png" width="200px" height="auto" hspace="20"/>
    <img src="https://raw.githubusercontent.com/wilburt/rave_flutter/master/screenshots/card_payment.png" width="200px" height="auto" hspace="20"/>
    <img src="https://raw.githubusercontent.com/wilburt/rave_flutter/master/screenshots/nigerian_bank_payment.png" width="200px" height="auto" hspace="20"/>
</p>


A robust Flutter plugin for accepting payment on Rave with
- [x] Card
- [x] Nigerian Bank Account
- [x] ACH Payments
- [x] Mobile money Francophone Africa
- [x] Mpesa
- [ ] Ghana Mobile Money
- [ ] Uganda Mobile Money


## Keys
- [Create your Rave staging keys from the sandbox environment](https://flutterwavedevelopers.readme.io/blog/how-to-get-your-staging-keys-from-the-rave-sandbox-environment)
- [Create your Rave live keys from the Rave Dashboard](https://flutterwavedevelopers.readme.io/blog/how-to-get-your-live-keys-from-the-rave-dashboard)


## Installation
To use this plugin, add `rave_flutter` as a dependency in your pubspec.yaml file.

Webview is required so enable `PlatformView` on iOS by adding:

```
<key>io.flutter.embedded_views_preview</key>
<true/
```
to Info.plist file

## Making Payment
Instantiate `RavePayInitializer` and pass it to `RavePayManager.prompt` along
with the `BuildContext`. The result of the transaction is the `Future` 
returned by `RavePayManager.initialize`

```
processTransaction() async {
    // Get a reference to RavePayInitializer
    var initializer = RavePayInitializer(
        amount: 500, publicKey: publicKey, encryptionKey: encryptionKey)
      ..country = "NG"
      ..currency = "NGN"
      ..email = "customer@email.com"
      ..fName = "Ciroma"
      ..lName = "Adekunle"
      ..narration = narration ?? ''
      ..txRef = txRef
      ..subAccounts = subAccounts
      ..acceptMpesaPayments = acceptMpesaPayment
      ..acceptAccountPayments = acceptAccountPayment
      ..acceptCardPayments = acceptCardPayment
      ..acceptAchPayments = acceptAchPayments
      ..acceptGHMobileMoneyPayments = acceptGhMMPayments
      ..acceptUgMobileMoneyPayments = acceptUgMMPayments
      ..staging = true
      ..isPreAuth = preAuthCharge
      ..displayFee = shouldDisplayFee;

    // Initialize and get the transaction result
    RaveResult response = await RavePayManager()
        .prompt(context: context, initializer: initializer);
  }
 ```
 
## Documentation
Documentation can be found [here](https://pub.dev/documentation/rave_flutter/latest/rave_flutter/rave_flutter-library.html).
 
## Contributing, Issues and Bug Reports
The project is open to public contribution. Please feel very free to contribute.
Experienced an issue or want to report a bug? Please, [report it here](https://github.com/wilburt/rave_flutter/issues). Remember to be as descriptive as possible.




