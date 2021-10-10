import 'dart:async';
import 'dart:convert';

import 'package:data/error_handle/exception.dart';
import 'package:data/models/number_trivia_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:remote/api/numbrt_trivia_service.dart';
import 'package:remote/datasource/number_trivia_remote_data_source_impl.dart';

import '../fixtures/fixture_reader.dart';

void main(){
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late ApiServiceImpl api;
  late DioAdapter dioAdapter;

  setUp((){
    dioAdapter = DioAdapter(dio: dioApi);
    api = ApiServiceImpl(dioApi);
    dataSource = NumberTriviaRemoteDataSourceImpl(api: api);
  });
  group("getConcreteNumberTrivia", (){

    const tNumber = 1;
    const tHeaders = <String, dynamic> {
      "Content-Type":"application/json"
    };
    const tNumberTrivia = NumberTriviaModel(text: "Test", number: "8");
    test("should return NumberTrivia when response code is 200 (success)", () async {
      // arrange
      dioAdapter.onGet(
          tNumber.toString(),
              //(server) => server.reply(200, json.decode(fixture("trivia_remote.json"))),
              (server) => server.reply(200, {
                "text": "Test",
                "number": 8,
                "found": true,
                "type": "trivia"
              }),
          headers: tHeaders
      );

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, tNumberTrivia
         // NumberTriviaModel.fromJson(json.decode(fixture("trivia_remote.json")))
      );
    });

    test("should throw a ServerException when the response code is 404 or other",
            () async {
      // arrange
      dioAdapter.onGet(
          tNumber.toString(),
          //(server) => server.reply(200, json.decode(fixture("trivia_remote.json"))),
             // (server) => server.reply(404, tNumberTrivia),
              (server) => server.reply(404, "not found"),
          headers: tHeaders
      );

      // act
      final call = dataSource.getConcreteNumberTrivia;

      // assert
      expect(call(tNumber), throwsA(isA<ServerException>())
        // NumberTriviaModel.fromJson(json.decode(fixture("trivia_remote.json")))
      );
    });
  });

  group("getRandomNumberTrivia", (){

    const tHeaders = <String, dynamic> {
      "Content-Type":"application/json"
    };
    const tNumberTrivia = NumberTriviaModel(text: "Test Text", number: "1");
    test("should return NumberTrivia when response code is 200 (success)", () async {
      // arrange
      dioAdapter.onGet(
          "random",
              (server) => server.reply(200, json.decode(fixture("trivia_remote.json"))),
          headers: tHeaders
      );

      // act
      final result = await dataSource.getRandomNumberTrivia();

      // assert
      expect(result, tNumberTrivia
         // NumberTriviaModel.fromJson(json.decode(fixture("trivia_remote.json")))
      );
    });

    test("should throw a ServerException when the response code is 404 or other",
            () async {
      // arrange
      dioAdapter.onGet(
          "random",
          //(server) => server.reply(200, json.decode(fixture("trivia_remote.json"))),
             // (server) => server.reply(404, tNumberTrivia),
              (server) => server.reply(404, "not found"),
          headers: tHeaders
      );

      // act
      final call = dataSource.getRandomNumberTrivia;

      // assert
      expect(call(), throwsA(isA<ServerException>())
        // NumberTriviaModel.fromJson(json.decode(fixture("trivia_remote.json")))
      );
    });
  });

}