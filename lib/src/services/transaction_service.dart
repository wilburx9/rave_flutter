import 'package:dio/dio.dart';
import 'package:rave_flutter/src/dto/charge_request_body.dart';
import 'package:rave_flutter/src/dto/fee_check_request_body.dart';
import 'package:rave_flutter/src/dto/validate_charge_request_body.dart';
import 'package:rave_flutter/src/exception/exception.dart';
import 'package:rave_flutter/src/models/charge_model.dart';
import 'package:rave_flutter/src/models/fee_check_model.dart';
import 'package:rave_flutter/src/models/requery_model.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:rave_flutter/src/services/http_service.dart';

class TransactionService {
  static TransactionService? get instance => getIt<TransactionService>();
  final HttpService? _httpService;

  static final String basePath = "/flwv3-pug/getpaidx/api";
  final String _feeEndpoint = "$basePath/fee";
  final String _chargeEndpoint = "$basePath/charge";
  final String _validateChargeEndpoint = "$basePath/validatecharge";
  final String _reQueryEndpoint = "$basePath/verify/mpesa";

  TransactionService._(this._httpService);

  factory TransactionService() {
    return TransactionService._(HttpService.instance);
  }

  Future<FeeCheckResponseModel> fetchFee(FeeCheckRequestBody body) async {
    try {
      final response =
          await this._httpService!.dio!.post(_feeEndpoint, data: body.toJson());
      return FeeCheckResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw RaveException(data: e.response?.data);
    } catch (e) {
      throw RaveException();
    }
  }

  Future<ChargeResponseModel> charge(ChargeRequestBody body) async {
    try {
      final response = await this
          ._httpService!
          .dio!
          .post(_chargeEndpoint, data: body.toJson());
      return ChargeResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw RaveException(data: e.response?.data);
    } catch (e) {
      throw RaveException();
    }
  }

  Future<ChargeResponseModel> validateCardCharge(
      ValidateChargeRequestBody body) async {
    try {
      final response = await this
          ._httpService!
          .dio!
          .post(_validateChargeEndpoint, data: body.toJson());
      return ChargeResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw RaveException(data: e.response?.data);
    } catch (e) {
      throw RaveException();
    }
  }

  Future<ReQueryResponseModel> reQuery(String pBFPubKey, flwRef) async {
    try {
      final response = await this._httpService!.dio!.post(_reQueryEndpoint,
          data: {"PBFPubKey": pBFPubKey, "flw_ref": flwRef});
      return ReQueryResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw RaveException(data: e.response?.data);
    } catch (e) {
      throw RaveException();
    }
  }
}
