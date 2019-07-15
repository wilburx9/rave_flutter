import 'package:get_it/get_it.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/services/transaction_service.dart';
import 'package:rave_flutter/src/services/http_service.dart';

GetIt getIt = GetIt()..allowReassignment = true;

class Repository {
  static Repository get instance => getIt<Repository>();
  RavePayInitializer initializer;

  Repository._(this.initializer);

  static bootStrap(RavePayInitializer initializer) {
    final httpService = HttpService(initializer);

    var repository = Repository._(initializer);

    getIt.registerSingleton<Repository>(repository);

    getIt.registerSingleton<HttpService>(httpService);

    getIt.registerLazySingleton<TransactionService>(() => TransactionService());

    getIt.registerLazySingleton<ConnectionBloc>(() => ConnectionBloc());

    return repository;
  }
}
