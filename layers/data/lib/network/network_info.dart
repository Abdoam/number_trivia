import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}
