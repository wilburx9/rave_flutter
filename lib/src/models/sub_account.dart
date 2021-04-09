import 'package:rave_flutter/src/common/rave_utils.dart';

class SubAccount {
  final String id;
  final String transactionSplitRatio;
  final String? transactionChargeType;
  final String? transactionCharge;

  SubAccount(this.id, this.transactionSplitRatio)
      : this.transactionChargeType = null,
        this.transactionCharge = null;

  Map<String, String?> toJson() {
    var map = Map<String, String?>();
    map[_idKey] = id;
    map[_ratioKey] = transactionSplitRatio;
    if (!isEmpty(transactionChargeType)) {
      map[_chargeTypeKey] = transactionChargeType;
    }

    if (!isEmpty(transactionCharge)) {
      map[_chargeKey] = transactionCharge;
    }
    return map;
  }
}

const _idKey = 'id';
const _ratioKey = 'transaction_split_ratio';
const _chargeTypeKey = 'transaction_charge_type';
const _chargeKey = 'transaction_charge';
