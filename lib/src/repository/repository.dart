import 'package:get_it/get_it.dart';
import 'package:rave_flutter/src/blocs/connection_bloc.dart';
import 'package:rave_flutter/src/blocs/transaction_bloc.dart';
import 'package:rave_flutter/src/common/rave_pay_initializer.dart';
import 'package:rave_flutter/src/services/bank_service.dart';
import 'package:rave_flutter/src/services/http_service.dart';
import 'package:rave_flutter/src/services/transaction_service.dart';

GetIt getIt = GetIt.instance..allowReassignment = true;

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

    getIt.registerLazySingleton<BankService>(() => BankService());

    getIt.registerLazySingleton<ConnectionBloc>(() => ConnectionBloc());

    getIt.registerLazySingleton<TransactionBloc>(() => TransactionBloc());

    return repository;
  }
}
