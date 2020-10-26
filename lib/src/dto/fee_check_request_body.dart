import 'package:equatable/equatable.dart';
import 'package:rave_flutter/src/common/payment_methods.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/dto/payload.dart';

class FeeCheckRequestBody extends Equatable {
  final String amount;
  final String pBFPubKey;
  final String card6;
  final String currency;
  final String pType;
  PAYMENT_METHOD _pMethod;

  FeeCheckRequestBody({
    this.amount,
    this.pBFPubKey,
    this.pType,
    this.card6,
    this.currency,
  });

  FeeCheckRequestBody.fromPayload(Payload p, {PAYMENT_METHOD method})
      : this.amount = p.amount,
        this.pBFPubKey = p.pbfPubKey,
        this.currency = p.currency,
        this.pType = null,
        this._pMethod = method,
        this.card6 = isEmpty(p.cardNo) ? p.cardBIN : p.cardNo.substring(0, 6);

  Map<String, dynamic> toJson() {
    var json = {
      "amount": amount,
      "PBFPubKey": pBFPubKey,
      "currency": currency,
    };

    if(_pMethod != null){
      switch(_pMethod){
        case PAYMENT_METHOD.UG_MOBILE_MONEY:
          json["pype"] = "3";
          break;
      }
    }else{
      if (!isEmpty(card6)) {
        json["card6"] = card6;
      }
      if (!isEmpty(pType)) {
        json["ptype"] = pType;
      }
    }
    return json;
  }

  @override
  List<Object> get props => [
        amount,
        pBFPubKey,
        pType,
        card6,
        currency,
      ];
}
