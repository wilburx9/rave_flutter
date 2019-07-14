import 'package:dio/dio.dart';
import 'package:rave_flutter/src/dto/fee_check_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/models/fee_check_model.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/services/http_service.dart';

class CardService {
  static CardService get instance => getIt<CardService>();

  final HttpService _httpService;

  static final String _basePath = "/flwv3-pug/getpaidx/api";
  final String _feeEndpoint = "$_basePath/fee";

  CardService._(this._httpService);

  factory CardService() {
    return CardService._(HttpService.instance);
  }

  Future<FeeCheckModel> fetchFee(FeeCheckRequestBody body) async {
    try {
      final response =
          await this._httpService.dio.post(_feeEndpoint, data: body.toJson());
      return FeeCheckModel.fromJson(response.data);
    } on DioError catch (e) {
      throw RaveException(data: e?.response?.data);
    } catch (e) {
      throw RaveException();
    }
  }
}
