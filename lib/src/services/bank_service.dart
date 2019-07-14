import 'package:async/async.dart';
import 'package:rave_flutter/src/models/bank.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/services/http_service.dart';

class BankService {
  static BankService get instance => getIt<BankService>();

  final HttpService _httpService;

  static final String _basePath = "/flwv3-pug/getpaidx/api";
  final String _bankEndpoint = "$_basePath/flwpbf-banks.js";

  BankService._(this._httpService);

  factory BankService() {
    return BankService._(HttpService.instance);
  }

  var _banksCache = AsyncMemoizer<List<Bank>>();

  Future<List<Bank>> get fetchBanks => _banksCache.runOnce(() async {
        final response = await this
            ._httpService
            .dio
            .post(_bankEndpoint, data: {'json': '1'});

        return (response.data as List).map((m) => Bank.fromJson(m)).toList();
      });
}