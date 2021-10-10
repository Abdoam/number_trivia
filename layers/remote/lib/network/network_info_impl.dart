import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:data/network/network_info.dart';

/*class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }
}*/

class NetworkInfoImpl implements NetworkInfo {
  final Client? client;
  NetworkInfoImpl({this.client});
  @override
  Future<bool> get isConnected async {
    try {
      final Response response = await ((client
          ?.get(Uri.parse('https://example.com/')))
          ?? Client().get(Uri.parse('https://example.com/')));
      return (response.statusCode == 200);
    } catch(_) {
      return false;
    }
  }
}

/*
class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

}*/
