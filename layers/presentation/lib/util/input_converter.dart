import 'package:dartz/dartz.dart';
import 'package:domain/error_handle/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
      //} catch (_){
    } on FormatException {
      return left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}