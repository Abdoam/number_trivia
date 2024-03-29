import 'dart:convert';

import 'package:data/error_handle/exception.dart';
import 'package:data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local/number_trivia_local_data_source_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks(
  [SharedPreferences]
)
void main(){
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
  final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture("trivia_cached.json"))
  );
  test("should return NumberTrivia from SharedPreferences when there is one in"
      " the cache", () async {
    // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture("trivia_cached.json"));
    // act
      final result = await dataSource.getLastNumberTrivia();
    // assert
      verify(mockSharedPreferences.getString(NumberTriviaLocalDataSourceImpl.CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
  });

  test("should throw a CacheException when there is not a cached value"
      " the cache", () async {
    // arrange
    when(mockSharedPreferences.getString(any))
        .thenReturn(null);
    // act
    final call = dataSource.getLastNumberTrivia;
    // assert
    expect(() => call(), throwsA(TypeMatcher<CacheException>()));
  });

  });


  group("cacheNumberTrivia", () {
    const tNumberTriviaModel = NumberTriviaModel(text: "text", number: "5");
    test("should call SharedPreferences to cache the data", () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) => Future.value(true));
      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          NumberTriviaLocalDataSourceImpl.CACHED_NUMBER_TRIVIA,
          expectedJsonString));
    });
  });

}