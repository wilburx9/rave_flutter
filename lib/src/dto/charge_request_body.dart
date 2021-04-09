import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:rave_flutter/src/common/rave_utils.dart';
import 'package:rave_flutter/src/dto/payload.dart';
import 'package:rave_flutter/src/repository/repository.dart';

class ChargeRequestBody extends Equatable {
  late final String pBFPubKey;
  late final String client;
  late final String alg;

  ChargeRequestBody.fromPayload({required Payload payload, String? type})
      : this.pBFPubKey = payload.pbfPubKey,
        this.alg = "3DES-24",
        this.client = getEncryptedData(json.encode(payload.toJson(type)),
            Repository.instance.initializer.encryptionKey);

  Map<String, dynamic> toJson() => {
        "PBFPubKey": pBFPubKey,
        "client": client,
        "alg": alg,
      };

  @override
  List<Object?> get props => [pBFPubKey, client, alg];
}
