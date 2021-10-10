import 'package:dartz/dartz.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:domain/repositories/number_trivia_repository.dart';
import 'package:domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRepository
])
void main() {
  late GetConcreteNumberTrivia usecase;
  late NumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: "1", text: "test");

  test('should get trivia for the number from the repository', () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    // act
    final result = await usecase(Params(number: tNumber));
    // assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}