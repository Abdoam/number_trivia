import 'dart:convert';

import 'package:data/datasoures/number_trivia_local_data_source.dart';
import 'package:data/error_handle/exception.dart';
import 'package:data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  static const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString == null) throw CacheException();
    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}
