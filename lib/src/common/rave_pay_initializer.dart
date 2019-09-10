import 'package:flutter/cupertino.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/models/sub_account.dart';

class RavePayInitializer {
  /// Your customer email. Must be provided otherwise your customer will be promted to input it
  String email;

  /// The amount to be charged in the supplied [currency]. Must be a valid non=null and
  /// positive double. Otherwise, the customer will be asked to input an
  /// amount (this is especially useful for donations).
  double amount;

  /// Rave's merchant account public key.
  String publicKey;

  /// Rave's merchant encryption key
  String encryptionKey;

  /// Transaction reference. It cannot be null or empty
  String txRef;

  /// Custom description added by the merchant.
  String narration;

  /// An ISO 4217 currency code (e.g USD, NGN). I cannot be empty or null. Defaults to NGN
  String currency;

  /// ISO 3166-1 alpha-2 country code (e.g US, NG). Defaults to NG
  String country;

  /// Your customer's first name.
  String fName;

  /// Your customer's last name.
  String lName;

  /// Your custom data in key-value pairs
  Map<String, String> meta;

  /// As list of sub-accounts. Sub accounts are your vendor's accounts that you
  /// want to settle per transaction.
  /// See https://developer.flutterwave.com/docs/split-payment
  List<SubAccount> subAccounts;

  /// plan id for recurrent payments. Only available for card payment.
  /// More info:
  ///
  /// https://developer.flutterwave.com/reference#create-payment-plan
  ///
  /// https://developer.flutterwave.com/docs/recurring-billing
  String paymentPlan;

  /// Whether to accept US ACH payments.
  /// `US` and `USD` needs to be set as [country] and [currency] respectively
  bool acceptAchPayments;

  /// Whether to request Mpesa payment details.
  /// `KE` and `KES` needs to be set as [country] and [currency] respectively
  bool acceptMpesaPayments;

  /// Whether to request card payment details
  bool acceptCardPayments;

  /// Whether to request account payment details
  bool acceptAccountPayments;

  /// Whether to request Ghana mobile money payment details.
  /// `GH` and `GHS` needs to be set as [country] and [currency] respectively
  bool acceptGHMobileMoneyPayments;

  /// Whether to request Uganda Mobile Money payment details.
  /// `UG` and `UGX` needs to be set as [country] and [currency] respectively
  bool acceptUgMobileMoneyPayments;

  /// Whether to route the payment to Sandbox APIs.
  bool staging;

  /// Whether to preauthorize the transaction. See: https://developer.flutterwave.com/reference#introduction-1
  bool isPreAuth;

  /// Whether to display the transaction fee to customer before processing payment
  bool displayFee;

  /// Whether to display the amount in the payment prompt
  bool displayAmount;

  /// Whether to display the email in the payment prompt
  bool displayEmail;

  /// Your company's logo. Displayed on the top-left of the payment prompt.
  /// Displays Flutterwave's logo if null
  Widget companyLogo;

  /// Company name. Displayed on the top right of the payment prompt.
  /// If null and [staging] is true, a "Demo" text is displayed.
  Widget companyName;

  /// URL to redirect to when a transaction is completed. This is useful for 3DSecure payments so we can redirect your customer back to a custom page you want to show them.
  String redirectUrl;

  /// The text that is displayed on the pay button. Defaults to "Pay [currency][amount]"
  String payButtonText;

  RavePayInitializer({
    @required this.amount,
    @required this.publicKey,
    @required this.encryptionKey,
    this.currency = Strings.ngn,
    this.country = Strings.ng,
    this.narration = '',
    this.fName = '',
    this.lName = '',
    this.meta,
    this.subAccounts,
    this.acceptAchPayments = false,
    this.acceptMpesaPayments = false,
    this.acceptCardPayments = true,
    this.acceptAccountPayments = true,
    this.acceptGHMobileMoneyPayments = false,
    this.acceptUgMobileMoneyPayments = false,
    this.isPreAuth = false,
    this.displayFee = true,
    bool staging,
    this.email,
    this.txRef,
    this.companyLogo,
    this.companyName,
    this.paymentPlan,
    this.displayAmount = true,
    this.displayEmail = true,
    this.redirectUrl = "https://payment-status-page.firebaseapp.com/",
    this.payButtonText,
  }) : this.staging = staging ?? isInDebugMode;
}
