import 'dart:convert';

import 'package:equatable/equatable.dart';
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

  ChargeRequestBody.fromPayload(Payload p)
      : this.pBFPubKey = p.pbfPubKey,
        this.alg = "3DES-24",
        this.client = RaveUtils.getEncryptedData(json.encode(p.toJson()),
            Repository.instance.initializer.encryptionKey);

  Map<String, dynamic> toJson() => {
        "PBFPubKey": pBFPubKey,
        "client": client,
        "alg": alg,
      };
}
