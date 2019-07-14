import 'package:meta/meta.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/models/bank.dart';

class Payload {
  String expiryMonth;
  String pbfPubKey;
  String ip;
  String lastName;
  String firstName;
  String currency;
  String country;
  String amount;
  String email;
  String expiryYear;
  String cvv;
  String deviceFingerprint;
  String cardNo;
  String paymentPlan;
  String network;
  String bvn;
  String voucher;
  bool isPreAuth;
  bool isUsBankCharge;
  String phoneNumber;
  String accountNumber;
  Bank bank;
  String passCode;
  String txRef;
  String meta = "";
  String subAccounts = "";
  String cardBIN;

  Payload.initFrmInitializer(RavePayInitializer i)
      : this.amount = i.amount.toString(),
        this.currency = i.currency,
        this.country = i.country,
        this.email = i.email,
        this.firstName = i.fName,
        this.lastName = i.lName,
        this.txRef = i.txRef,
        this.meta = i.meta,
        this.subAccounts = i.subAccounts,
        this.isPreAuth = i.isPreAuth,
        this.pbfPubKey = i.publicKey;

  Payload(
      {@required this.expiryMonth,
      @required this.pbfPubKey,
      @required this.ip,
      @required this.lastName,
      @required this.firstName,
      @required this.amount,
      @required this.email,
      @required this.expiryYear,
      @required this.cvv,
      @required this.deviceFingerprint,
      @required this.cardNo,
      @required this.paymentPlan,
      @required this.network,
      @required this.bvn,
      @required this.voucher,
      @required this.phoneNumber,
      @required this.accountNumber,
      @required this.passCode,
      this.currency = Strings.ngn,
      this.country = Strings.ng,
      this.isPreAuth = false,
      this.isUsBankCharge = false,
      this.txRef,
      this.cardBIN});
}
