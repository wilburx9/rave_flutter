import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rave_flutter/src/common/payment_methods.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/repository/repository.dart';

class ChargeRequestBody extends Equatable {
  final String pBFPubKey;
  final String client;
  final String alg;

  ChargeRequestBody({
    this.pBFPubKey,
    this.client,
    this.alg,
  });

  ChargeRequestBody.fromPayload({@required Payload payload, String type,PAYMENT_METHOD paymentMethod})
      : this.pBFPubKey = payload.pbfPubKey,
        this.alg = "3DES-24",
        this.client = getEncryptedData(json.encode(payload.toJson(type,paymentMethod: paymentMethod)),
            Repository.instance.initializer.encryptionKey);

  Map<String, dynamic> toJson() => {
        "PBFPubKey": pBFPubKey,
        "client": client,
        "alg": alg,
      };

  @override
  List<Object> get props => [pBFPubKey, client, alg];
}
