
import 'package:data/datasoures/number_trivia_local_data_source.dart';
import 'package:data/datasoures/number_trivia_remote_data_source.dart';
import 'package:data/network/network_info.dart';
import 'package:data/repositories/number_trivia_repository_impl.dart';
import 'package:domain/repositories/number_trivia_repository.dart';
import 'package:domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:domain/usecases/GetRandomNumberTrivia.dart';
import 'package:get_it/get_it.dart';
import 'package:local/number_trivia_local_data_source_impl.dart';
import 'package:presentation/util/input_converter.dart';
import 'package:remote/api/numbrt_trivia_service.dart';
import 'package:remote/datasource/number_trivia_remote_data_source_impl.dart';
import 'package:remote/network/network_info_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureInjection() async {
  await setupDataDependencies();
  setupPresentationDependencies();
  setupRepositories();
  setupUsecases();
}

Future<void> setupDataDependencies() async {
  // External
  // Remote
  getIt.registerLazySingleton<NumberTriviaRemoteDataSource>(
          () => NumberTriviaRemoteDataSourceImpl(api: getIt<ApiService>())
  );

  getIt.registerLazySingleton<ApiService>(
          () => ApiServiceImpl(dioApi)
  );

  // Local
  getIt.registerLazySingleton<NumberTriviaLocalDataSource>(
          () => NumberTriviaLocalDataSourceImpl(getIt<SharedPreferences>())
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(
            () => prefs
  );

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}

void setupPresentationDependencies() {
  // Features - Number Trivia
/*  getIt.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
      getConcreteNumberTrivia: getIt<GetConcreteNumberTrivia>(),
      getRandomNumberTrivia: getIt<GetRandomNumberTrivia>(),
      inputConverter: getIt<InputConverter>()
  ));*/

  // Core
  getIt.registerLazySingleton<InputConverter>(
          () => InputConverter()
  );
}

void setupRepositories() {
  // Repository
  getIt.registerLazySingleton<NumberTriviaRepository>(
          () => NumberTriviaRepositoryImpl(
          localDataSource: getIt<NumberTriviaLocalDataSource>(),
          remoteDataSource: getIt<NumberTriviaRemoteDataSource>(),
          networkInfo: getIt<NetworkInfo>())
  );
}

void setupUsecases() {
  // Use cases
  getIt.registerLazySingleton<GetConcreteNumberTrivia>(
          () => GetConcreteNumberTrivia(getIt<NumberTriviaRepository>())
  );

  getIt.registerLazySingleton<GetRandomNumberTrivia>(
          () => GetRandomNumberTrivia(getIt<NumberTriviaRepository>())
  );
}
