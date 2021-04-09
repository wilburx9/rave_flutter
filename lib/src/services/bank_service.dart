import 'package:async/async.dart';
import 'package:rave_flutter/src/models/bank_model.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/services/http_service.dart';

class BankService {
  static BankService? get instance => getIt<BankService>();

  final HttpService? _httpService;

  static final String _basePath = "/flwv3-pug/getpaidx/api";
  final String _bankEndpoint = "$_basePath/flwpbf-banks.js";

  BankService._(this._httpService);

  factory BankService() {
    return BankService._(HttpService.instance);
  }

  var _banksCache = AsyncMemoizer<List<BankModel>>();

  Future<List<BankModel>> get fetchBanks => _banksCache.runOnce(() async {
        final response = await this
            ._httpService!
            .dio!
            .get(_bankEndpoint, queryParameters: {'json': '1'});

        var banks =
            (response.data as List).map((m) => BankModel.fromJson(m)).toList();
        banks.sort((a, b) => a.name!.compareTo(b.name!)); // Sort alphabetically
        return banks;
      });
}
