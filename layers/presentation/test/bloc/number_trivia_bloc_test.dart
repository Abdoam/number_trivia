import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:domain/error_handle/failures.dart';
import 'package:domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:domain/usecases/GetRandomNumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:presentation/bloc/number_trivia_bloc.dart';
import 'package:presentation/util/input_converter.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(getRandomNumberTrivia: mockGetRandomNumberTrivia,
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test("initialState should be empty", () => expect(bloc.state, equals(Empty())));

  blocTest(
    'emits [] when nothing is added',
    build: () => bloc,
    expect: () => [],
  );

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: "1");
    void setUpMockInputConverterSuccess(){
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }
    void setUpMockGetConcreteNumberTriviaSuccess(){
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    }
    blocTest(
      '''should call InputConverter to validate and convert the string to 
    an unsigned integer''',
      build: () => bloc,
      act: (NumberTriviaBloc bloc) {
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
      verify: (_){
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    blocTest(
      '''should emit [Error] when the input is invalid''',
      build: () => bloc,
      act: (NumberTriviaBloc bloc) {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [Empty(), const Error(message: invalidInputFailureMessage)]
    );

    blocTest(
        '''should get data from the concrete use case''',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaSuccess();
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
        verify: (_){
          verify(mockGetConcreteNumberTrivia.call(Params(number: tNumberParsed)));
        },
        expect: () => [Empty(), Loading(), const Loaded(trivia: tNumberTrivia)]
    );

    blocTest(
        '''should emit [Loading, Error] when getting data fails''',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
        verify: (_){
          verify(mockGetConcreteNumberTrivia.call(Params(number: tNumberParsed)));
        },
        expect: () => [Empty(), Loading(), const Error(message: serverFailureMessage)]
    );

    blocTest(
        '''should emit [Loading, Error] when getting when Error on cache''',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((realInvocation) async => Left(CacheFailure()));
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
        verify: (_){
          verify(mockGetConcreteNumberTrivia.call(Params(number: tNumberParsed)));
        },
        expect: () => [Empty(), Loading(), const Error(message: cacheFailureMessage)]
    );
  });
  group('GetRandomNumberTrivia', () {
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: "1");
    void setUpMockGetRandomNumberTriviaSuccess(){
      when(mockGetRandomNumberTrivia.call())
          .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    }
    blocTest(
        '''should get data from the random use case''',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          setUpMockGetRandomNumberTriviaSuccess();
          bloc.add(GetTriviaForRandomNumber());
        },
        verify: (_){
          verify(mockGetRandomNumberTrivia.call());
        },
        expect: () => [Empty(), Loading(), const Loaded(trivia: tNumberTrivia)]
    );

    blocTest(
        '''should emit [Loading, Error] when getting data fails''',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          when(mockGetRandomNumberTrivia.call())
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
          bloc.add(GetTriviaForRandomNumber());
        },
        verify: (_){
          verify(mockGetRandomNumberTrivia.call());
        },
        expect: () => [Empty(), Loading(), const Error(message: serverFailureMessage)]
    );

    blocTest(
        '''should emit [Loading, Error] when getting when Error on cache''',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          when(mockGetRandomNumberTrivia.call())
          .thenAnswer((realInvocation) async => Left(CacheFailure()));
          bloc.add(GetTriviaForRandomNumber());
        },
        verify: (_){
          verify(mockGetRandomNumberTrivia.call());
        },
        expect: () => [Empty(), Loading(), const Error(message: cacheFailureMessage)]
    );
  });

}