import 'package:flutter/cupertino.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/responses/sub_account.dart';

class RavePayInitializer {
  // TODO: Write documentation
  String email; //  TODO: Validate before payment
  double amount;
  String publicKey;
  String encryptionKey;
  String txRef;
  String narration;
  String currency;
  String country;
  String fName;
  String lName;
  String meta;
  String _subAccounts;
  String paymentPlan;
  bool acceptAchPayments;
  bool acceptMpesaPayments;
  bool acceptCardPayments;
  bool acceptAccountPayments;
  bool acceptGHMobileMoneyPayments;
  bool acceptUgMobileMoneyPayments;
  bool staging;
  bool isPreAuth;
  bool displayFee;

  RavePayInitializer({
    @required this.amount,
    @required this.publicKey,
    @required this.encryptionKey,
    this.currency = Strings.ng,
    this.country = Strings.ngn,
    this.narration = '',
    this.fName = '',
    this.lName = '',
    this.meta = '',
    List<SubAccount> subAccounts,
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
    this.paymentPlan,
  })  : this.staging = staging ?? isInDebugMode,
        this._subAccounts = SubAccount.serializeList(subAccounts) ?? '';

  String get subAccounts => _subAccounts;
}
