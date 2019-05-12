import 'dart:convert';

import 'package:rave_flutter/src/common/rave_utils.dart';

class SubAccount {
  final String id;
  final String transactionSplitRatio;
  final String transactionChargeType;
  final String transactionCharge;

  SubAccount(this.id, this.transactionSplitRatio)
      : this.transactionChargeType = null,
        this.transactionCharge = null;

  Map<String, String> toMap() {
    var map = {_idKey: id, _ratioKey: transactionSplitRatio};
    if (!RaveUtils.isEmpty(transactionChargeType)) {
      map[_chargeTypeKey] = transactionChargeType;
    }

    if (!RaveUtils.isEmpty(transactionCharge)) {
      map[_chargeKey] = transactionCharge;
    }
    return map;
  }

  static String serializeList(List<SubAccount> subAccounts) {
    return jsonEncode(subAccounts?.map((a) => a.toMap())?.toList());
  }
}

const _idKey = 'id';
const _ratioKey = 'transaction_split_ratio';
const _chargeTypeKey = 'transaction_charge_type';
const _chargeKey = 'transaction_charge';
