import 'package:dartz/dartz.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:domain/error_handle/failures.dart';
import 'package:domain/repositories/number_trivia_repository.dart';
import 'package:domain/usecases/base/use_case.dart';

class GetRandomNumberTrivia extends NoParamUseCase<NumberTrivia>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository): super();
  @override
  Future<Either<Failure, NumberTrivia>> call() {
    return repository.getRandomNumberTrivia();
  }
}