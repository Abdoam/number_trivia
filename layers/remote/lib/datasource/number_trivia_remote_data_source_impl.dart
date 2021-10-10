import 'dart:convert';

import 'package:data/datasoures/number_trivia_remote_data_source.dart';
import 'package:data/models/number_trivia_model.dart';
import '../api/numbrt_trivia_service.dart';

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  final ApiService api;
  NumberTriviaRemoteDataSourceImpl({required this.api});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getNumberTriviaFromUrl(number.toString());

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getNumberTriviaFromUrl("random");

  Future<NumberTriviaModel> _getNumberTriviaFromUrl(String url) async {
    return NumberTriviaModel.fromJson(json.decode(await api.get(path: url,
        headers: <String, dynamic> {
          "Content-Type":"application/json"
        })));
  }
}