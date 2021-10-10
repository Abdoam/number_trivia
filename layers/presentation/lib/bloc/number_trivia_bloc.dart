import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:domain/error_handle/failures.dart';
import 'package:domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:domain/usecases/GetRandomNumberTrivia.dart';
import 'package:equatable/equatable.dart';
import 'package:presentation/util/input_converter.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = "Server Failure";
// must be integer (code) to localization because bloc must not
// access the localization
const String cacheFailureMessage = "Cache Failure";
const String invalidInputFailureMessage =
    "Invalid Input - The number must be a positive or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getRandomNumberTrivia,
      required this.getConcreteNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      emit(Empty());
    });
    on<GetTriviaForConcreteNumber>((event, emit) async {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        await inputEither.fold<Future>(
          (failure) async => emit(Error(message: _mapFailureToMessage(failure))),
          (integer) async {
            emit(Loading());
            final result =
                await getConcreteNumberTrivia.call(Params(number: integer));
            _eitherLoadedOrErrorState(result, emit);
          },
        );
      });
    on<GetTriviaForRandomNumber>((event, emit) async {
        emit(Loading());
        final result = await getRandomNumberTrivia.call();
        _eitherLoadedOrErrorState(result, emit);
    });
  }

  void _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> result, Emitter<NumberTriviaState> emit) {
    result.fold((failure) {
      emit(Error(message: _mapFailureToMessage(failure)));
    }, (numberTrivia) => emit(Loaded(trivia: numberTrivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      case InvalidInputFailure:
        return invalidInputFailureMessage;
      default:
        return "Unexpected error";
    }
  }
}
