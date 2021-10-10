import 'package:data/error_handle/exception.dart';
import 'package:data/models/number_trivia_model.dart';
import 'package:dio/dio.dart';

const baseUrl = 'http://numbersapi.com/';

var dioOptions = BaseOptions(baseUrl: baseUrl,
    receiveDataWhenStatusError: true);
Dio dioApi = Dio(dioOptions);

abstract class ApiService {
  //Future<T> post<T>(String path, {dynamic data});
  Future<T> get<T>({required String path, Map<String, dynamic>? query,
    Map<String, dynamic>? headers});
}

class ApiServiceImpl extends ApiService {
  final Dio _dio;

  ApiServiceImpl(this._dio);

  @override
  Future<T> get<T>({required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers}) {
    return _dio.get<T>(
        path, queryParameters: query, options: Options(headers: headers)).then((
        response) {
      return response.data!;
    }).catchError((error) {
      throw ServerException();
    });
  }

/*  @override
  Future<T> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(path, data: data).then((response) {
      return response.data!;
    }).catchError((error) {
      throw error;
    });
  }*/
}