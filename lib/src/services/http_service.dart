import 'dart:io';

import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/repository/repository.dart';
import 'package:dio/dio.dart';

class HttpService {
  static HttpService get instance => getIt<HttpService>();

  Dio _dio;

  Dio get dio => _dio;

  HttpService._(RavePayInitializer initializer) {
    var options = BaseOptions(
      baseUrl: initializer.staging
          ? "https://ravesandbox.azurewebsites.net"
          : "https://raveapi.azurewebsites.net",
      responseType: ResponseType.json,
      connectTimeout: 60000,
      receiveTimeout: 60000,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );
    _dio = Dio(options);
    if (initializer.staging) {
      _dio.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }

  factory HttpService(RavePayInitializer initializer) =>
      HttpService._(initializer);
}
