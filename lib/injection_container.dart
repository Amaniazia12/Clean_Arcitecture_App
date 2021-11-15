import 'package:architecture/core/network/network_info.dart';
import 'package:architecture/core/utils/input_converter.dart';
import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_local_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_remote_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/data/repository/number_trivia_repository_impl.dart';
import 'package:architecture/featuers/numberTrivia/domain/repository/number_trivia_repository.dart';
import 'package:architecture/featuers/numberTrivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/domain/usecases/get_random_number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //bloc
  sl.registerFactory(() => NumberTriviaBloc(
        inputConverter: sl(),
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
      ));
  //use case
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImbl(sl()));
  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            numberTriviaLocalDataSources: sl(),
            numberTriviaRemotDataSources: sl(),
            networkInfo: sl(),
          ));
  //Data source
  sl.registerLazySingleton<NumberTriviaLocalDataSources>(
      () => NumberTriviaLocalDataSourcesImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemotDataSources>(
      () => NumberTriviaRemotDataSourcesImpl(client: sl()));
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImbl(sl()));
  //! External
  //@preResolve
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
