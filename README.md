# Rave Flutter

[![pub package](https://img.shields.io/pub/v/rave_flutter.svg)](https://pub.dartlang.org/packages/rave_flutter)

A robust Flutter plugin for accepting payment on Rave with
- [x] Card
- [ ] Bank Account
- [ ] Mpesa
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
Instantiate `RavePayInitializer` and pass it to `RavePayManager.initialize` along
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
        .initialize(context: context, initializer: initializer);
  }
 ```
 
 
## Contributing, Issues and Bug Reports
The project is open to public contribution. Please feel very free to contribute.
Experienced an issue or want to report a bug? Please, [report it here](https://github.com/wilburt/rave_flutter/issues). Remember to be as descriptive as possible.




