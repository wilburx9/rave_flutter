import 'dart:convert';

import 'package:async/async.dart';
import 'package:rave_flutter/src/models/Bank.dart';
import 'package:rave_flutter/src/rave_pay_manager.dart';
import 'package:http/http.dart' as http;

class BanksHolder {
  static final _banksHolder = BanksHolder._internal();

  BanksHolder._internal();

  factory BanksHolder() {
    return _banksHolder;
  }

  var _banksCache = AsyncMemoizer<List<Bank>>();

  Future<List<Bank>> get banks => _banksCache.runOnce(() async {
        List<Bank> banks = [];
        String url = RavePayManager()
            .buildUrl('flwv3-pug/getpaidx/api/flwpbf-banks.js', params: {'json': '1'});
        http.Response response = await http.get(url);
        List data = jsonDecode(response.body);
        for (var map in data) {
          banks.add(Bank.deserialize(map));
        }
        return banks;
      });
}
