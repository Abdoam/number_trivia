import 'package:dartz/dartz.dart';
import 'package:data/network/network_info.dart';
import 'package:data/datasoures/number_trivia_local_data_source.dart';
import 'package:data/datasoures/number_trivia_remote_data_source.dart';
import 'package:data/error_handle/exception.dart';
import 'package:data/models/number_trivia_model.dart';
import 'package:data/repositories/number_trivia_repository_impl.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:domain/error_handle/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaLocalDataSource, NumberTriviaRemoteDataSource, NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });


  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
    body();
  });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      body();
    });
  }

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber.toString(), text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if the device is online", () async {
      // arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((realInvocation) async => tNumberTriviaModel);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline( () {

      test("should return remote data when the call to remote data source is successful",
              () async {
        // arrange
                when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                    .thenAnswer((realInvocation) async => tNumberTriviaModel);
        // act
                final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
                verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
                expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return server failure when the call to remote data source is unsuccessful",
              () async {
        // arrange
                when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                    .thenThrow(ServerException());
        // act
                final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
                verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
                verifyZeroInteractions(mockLocalDataSource);
                expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline( () {
      test("should return last locally cached data when the cached data is present",
              () async {
            // arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((realInvocation) async => tNumberTriviaModel);
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test("should return CacheFailure when there is no cached data present",
              () async {
            // arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });

  group("getRandomNumberTrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel(number: tNumber.toString(), text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if the device is online", () async {
      // arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((realInvocation) async => tNumberTriviaModel);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline( () {

      test("should return remote data when the call to remote data source is successful",
              () async {
            // arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((realInvocation) async => tNumberTriviaModel);
            // act
            final result = await repository.getRandomNumberTrivia();
            // assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test("should return server failure when the call to remote data source is unsuccessful",
              () async {
            // arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());
            // act
            final result = await repository.getRandomNumberTrivia();
            // assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });
    });

    runTestsOffline( () {
      test("should return last locally cached data when the cached data is present",
              () async {
            // arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((realInvocation) async => tNumberTriviaModel);
            // act
            final result = await repository.getRandomNumberTrivia();
            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test("should return CacheFailure when there is no cached data present",
              () async {
            // arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // act
            final result = await repository.getRandomNumberTrivia();
            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
}
