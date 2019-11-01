import 'package:meta/meta.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/models/bank_model.dart';
import 'package:rave_flutter/src/models/sub_account.dart';

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
  String cardNo;
  String paymentPlan;
  String network;
  String bvn;
  String voucher;
  bool isPreAuth;
  bool isUsBankCharge;
  String phoneNumber;
  String accountNumber;
  BankModel bank;
  String passCode;
  String txRef;
  Map<String, String> meta;
  List<SubAccount> subAccounts;
  String cardBIN;
  String pin;
  String suggestedAuth;
  String narration;
  String billingZip;
  String billingCity;
  String billingAddress;
  String billingState;
  String billingCountry;
  String redirectUrl;
  String paymentType;

  Payload.fromInitializer(RavePayInitializer i)
      : this.amount = i.amount.toString(),
        this.currency = i.currency,
        this.country = i.country,
        this.email = i.email,
        this.firstName = i.fName,
        this.lastName = i.lName,
        this.txRef = i.txRef,
        this.meta = i.meta,
        this.subAccounts = i.subAccounts,
        this.redirectUrl = i.redirectUrl,
        this.isPreAuth = i.isPreAuth,
        this.pbfPubKey = i.publicKey,
        this.paymentPlan = i.paymentPlan;

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

  Map<String, dynamic> toJson(String paymentType) {
    var json = <String, dynamic>{
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
    };

    putIfNotNull(map: json, key: "payment_type", value: paymentType);
    putIfNotNull(map: json, key: "expirymonth", value: expiryMonth);
    putIfNotNull(map: json, key: "expiryyear", value: expiryYear);
    putIfNotNull(map: json, key: "cvv", value: cvv);
    putIfNotNull(map: json, key: "cardno", value: cardNo);
    putIfNotNull(map: json, key: "accountbank", value: bank?.code);
    putIfNotNull(map: json, key: "bvn", value: bvn);
    putIfNotNull(map: json, key: "accountnumber", value: accountNumber);
    putIfNotNull(map: json, key: "passcode", value: passCode);
    putIfNotNull(map: json, key: "phonenumber", value: phoneNumber);
    putIfNotNull(map: json, key: "payment_plan", value: paymentPlan);
    putIfNotNull(map: json, key: "billingzip", value: billingZip);
    putIfNotNull(map: json, key: "pin", value: pin);
    putIfNotNull(map: json, key: "suggested_auth", value: suggestedAuth);
    putIfNotNull(map: json, key: "billingcity", value: billingCity);
    putIfNotNull(map: json, key: "billingaddress", value: billingAddress);
    putIfNotNull(map: json, key: "billingstate", value: billingState);
    putIfNotNull(map: json, key: "billingcountry", value: billingCountry);
    putIfNotNull(map: json, key: "billingzip", value: billingZip);

    putIfNotNull(
        map: json, key: "charge_type", value: isPreAuth ? "preauth" : null);

    if (meta == null) meta = {};
    meta["sdk"] = "flutter";
    json["meta"] = [
      for (var e in meta.entries) {"metaname": e.key, "metavalue": e.value}
    ];
    putIfNotNull(
      map: json,
      key: "redirect_url",
      value: redirectUrl,
    );
    putIfNotNull(
        map: json,
        key: "subaccounts",
        value: subAccounts == null || subAccounts.isEmpty
            ? null
            : subAccounts.map((a) => a.toJson()).toList());
    return json;
  }
}
