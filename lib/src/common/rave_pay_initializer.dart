import 'package:flutter/cupertino.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';

class RavePayInitializer {
  // TODO: Write documentation
  String email;
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
  String subAccounts;
  String paymentPlan;
  bool withAch;
  bool withMpesa;
  bool withCard;
  bool withAccount;
  bool withGHMobileMoney;
  bool withUgMobileMoney;
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
    this.subAccounts = '',
    this.withAch = false,
    this.withMpesa = false,
    this.withCard = true,
    this.withAccount = true,
    this.withGHMobileMoney = false,
    this.withUgMobileMoney = false,
    this.isPreAuth = false,
    this.displayFee = true,
    bool staging,
    this.email,
    this.txRef,
    this.paymentPlan,
  }) : this.staging = staging ?? isInDebugMode;
}
