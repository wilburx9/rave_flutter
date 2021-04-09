import 'package:equatable/equatable.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/dto/payload.dart';

class FeeCheckRequestBody extends Equatable {
  final String amount;
  final String pBFPubKey;
  final String? card6;
  final String currency;
  final String? pType;

  FeeCheckRequestBody.fromPayload(Payload p)
      : this.amount = p.amount,
        this.pBFPubKey = p.pbfPubKey,
        this.currency = p.currency,
        this.pType = null,
        this.card6 = isEmpty(p.cardNo) ? p.cardBIN : p.cardNo!.substring(0, 6);

  Map<String, String> toJson() {
    var json = {
      "amount": amount,
      "PBFPubKey": pBFPubKey,
      "currency": currency,
    };
    if (!isEmpty(card6)) {
      json["card6"] = card6!;
    }
    if (!isEmpty(pType)) {
      json["ptype"] = pType!;
    }
    return json;
  }

  @override
  List<Object?> get props => [
        amount,
        pBFPubKey,
        pType,
        card6,
        currency,
      ];
}
