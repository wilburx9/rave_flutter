import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/models/bank_model.dart';
import 'package:rave_flutter/src/models/sub_account.dart';

class Payload {
  String? expiryMonth;
  String pbfPubKey;
  String? ip;
  String? lastName;
  String? firstName;
  String currency;
  String country;
  String amount;
  String? email;
  String? expiryYear;
  String? cvv;
  String? cardNo;
  String? paymentPlan;
  String? network;
  String? bvn;
  String? voucher;
  bool isPreAuth;
  bool isUsBankCharge;
  bool isMobileMoneyFranco;
  bool isMpesa;
  bool isMpesaLipa;
  String? phoneNumber;
  String? accountNumber;
  BankModel? bank;
  String? passCode;
  String? txRef;
  String? orderRef;
  Map<String, String?>? meta;
  List<SubAccount>? subAccounts;
  String? cardBIN;
  String? pin;
  String? suggestedAuth;
  String? narration;
  String? billingZip;
  String? billingCity;
  String? billingAddress;
  String? billingState;
  String? billingCountry;
  String? redirectUrl;
  String? paymentType;

  Payload.fromInitializer(RavePayInitializer i)
      : this.amount = i.amount.toString(),
        this.currency = i.currency,
        this.country = i.country,
        this.email = i.email,
        this.firstName = i.fName,
        this.lastName = i.lName,
        this.txRef = i.txRef,
        this.orderRef = i.orderRef,
        this.meta = i.meta,
        this.subAccounts = i.subAccounts,
        this.redirectUrl = i.redirectUrl,
        this.isPreAuth = i.isPreAuth,
        this.pbfPubKey = i.publicKey,
        this.paymentPlan = i.paymentPlan,
        this.isUsBankCharge = i.acceptAchPayments,
        this.isMobileMoneyFranco = i.acceptMobileMoneyFrancophoneAfricaPayments,
        this.isMpesa = i.acceptMpesaPayments,
        this.isMpesaLipa = i.acceptMpesaPayments,
        this.narration = i.narration ?? "";

  Payload(
      {required this.expiryMonth,
      required this.pbfPubKey,
      required this.ip,
      required this.lastName,
      required this.firstName,
      required this.amount,
      required this.email,
      required this.expiryYear,
      required this.cvv,
      required this.cardNo,
      required this.paymentPlan,
      required this.network,
      required this.bvn,
      required this.voucher,
      required this.phoneNumber,
      required this.accountNumber,
      required this.passCode,
      this.currency = Strings.ngn,
      this.country = Strings.ng,
      this.isPreAuth = false,
      this.isUsBankCharge = false,
      this.isMobileMoneyFranco = false,
      this.isMpesa = false,
      this.isMpesaLipa = false,
      this.txRef,
      this.orderRef,
      this.cardBIN});

  Map<String?, dynamic> toJson(String? paymentType) {
    var json = <String?, dynamic>{
      "narration": narration,
      "PBFPubKey": pbfPubKey,
      "lastname": lastName,
      "firstname": firstName,
      "currency": currency,
      "country": country,
      "amount": amount,
      "email": email,
      "txRef": txRef,
      "redirect_url": redirectUrl,
      "payment_type": paymentType,
      "expirymonth": expiryMonth,
      "expiryyear": expiryYear,
      "cvv": cvv,
      "cardno": cardNo,
      "accountbank": bank?.code,
      "bvn": bvn,
      "accountnumber": accountNumber,
      "passcode": passCode,
      "phonenumber": phoneNumber,
      "payment_plan": paymentPlan,
      "billingzip": billingZip,
      "pin": pin,
      "suggested_auth": suggestedAuth,
      "billingcity": billingCity,
      "billingaddress": billingAddress,
      "billingstate": billingState,
      "billingcountry": billingCountry,
      "charge_type": isPreAuth ? "preauth" : null,
      "is_us_bank_charge": isUsBankCharge,
      "is_mobile_money_franco": isMobileMoneyFranco,
      "is_mpesa": isMpesa,
      "is_mpesa_lipa": isMpesaLipa,
      "subaccounts": subAccounts == null || subAccounts!.isEmpty
          ? null
          : subAccounts!.map((a) => a.toJson()).toList(),
    };

    if (meta == null) meta = {};
    if (isMobileMoneyFranco) {
      meta!["orderRef"] = orderRef;
    }
    meta!["sdk"] = "flutter";
    json["meta"] = [
      for (var e in meta!.entries) {"metaname": e.key, "metavalue": e.value}
    ];
    return json
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }
}
