import 'package:equatable/equatable.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/dto/payload.dart';

class FeeCheckRequestBody extends Equatable {
  final String amount;
  final String pBFPubKey;
  final String card6;
  final String currency;
  final String pType;

  FeeCheckRequestBody({
    this.amount,
    this.pBFPubKey,
    this.pType,
    this.card6,
    this.currency,
  });

  FeeCheckRequestBody.fromPayload(Payload p)
      : this.amount = p.amount,
        this.pBFPubKey = p.pbfPubKey,
        this.currency = p.currency,
        this.pType = null,
        this.card6 =
            RaveUtils.isEmpty(p.cardNo) ? p.cardBIN : p.cardNo.substring(0, 6);

  Map<String, dynamic> toJson() {
    var json = {
      "amount": amount,
      "PBFPubKey": pBFPubKey,
      "card6": card6,
      "currency": currency
    };
    if (!RaveUtils.isEmpty(pType)) {
      json["ptype"] = pType;
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
