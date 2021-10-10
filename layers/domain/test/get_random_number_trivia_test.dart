import 'package:dartz/dartz.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:domain/repositories/number_trivia_repository.dart';
import 'package:domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:domain/usecases/GetRandomNumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRepository
])
void main() {
  late GetRandomNumberTrivia usecase;
  late NumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: "1", text: "test");

  test('should get trivia from the repository', () async {
    // arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    // act
    final result = await usecase();
    // assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}