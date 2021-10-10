import 'package:dartz/dartz.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:domain/error_handle/failures.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}