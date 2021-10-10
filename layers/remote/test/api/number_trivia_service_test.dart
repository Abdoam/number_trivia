import 'dart:convert';

import 'package:data/error_handle/exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:remote/api/numbrt_trivia_service.dart';

import '../fixtures/fixture_reader.dart';

void main(){
  late ApiServiceImpl api;
  late DioAdapter dioAdapter;

  setUp((){
    dioAdapter = DioAdapter(dio: dioApi);
    api = ApiServiceImpl(dioApi);
  });
  group("get", () {
    final res = json.decode(fixture("trivia_remote.json"));
    final headers = json.decode('{"Content-Type":"application/json"}');
    const numberRoute = '1';
    test("should return correct data if there is connection", () async {
      // arrange
      dioAdapter.onGet(
        numberRoute,
            (server) => server.reply(200, res),
        headers: headers
      );

      // act
      final result = await api.get(path: numberRoute, headers: headers);

      expect(result, equals(res));
    });

    test("should throw error if there is error", () async {
      // arrange
      dioAdapter.onGet(
          numberRoute,
              (server) => server.reply(200, null),
          headers: headers
      );

      // act
      final call = api.get;
      //
      expect(call(path: numberRoute, headers: headers), throwsA(isA<ServerException>()));
      // expect(() async {await call(path: "1", headers: headers);}, throwsA(isA<ServerException>()));
    });
  });

}