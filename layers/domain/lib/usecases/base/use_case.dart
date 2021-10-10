import 'package:dartz/dartz.dart';
import 'package:domain/error_handle/failures.dart';
import 'package:flutter/foundation.dart';

abstract class UseCase<T, P> {
  @mustCallSuper
  UseCase();

  Future<Either<Failure, T>> call(P params);
}

abstract class NoParamUseCase<T> {
  @mustCallSuper
  NoParamUseCase();

  Future<Either<Failure, T>> call();
}
