import 'package:data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [CacheException] if no cached data is present. // NoLocalDataException
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// cache [NumberTriviaModel]
  ///
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}