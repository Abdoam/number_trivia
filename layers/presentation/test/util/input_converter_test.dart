import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/util/input_converter.dart';

void main(){
  late InputConverter inputConverter;
  
  setUp((){
    inputConverter = InputConverter();
  });
  
  group('stringToUnsignedInteger', () { 
    
    test('should return an integer when the string represent an unsigned integer',
        () async {
          // arrange
          const str = "123";
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, const Right(123));
     });

    test('should return a Failure when the string is not an integer',
            () async {
          // arrange
          const str = "123j";
          const str1 = "1.0";
          const str2 = "ABC";
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          final result1 = inputConverter.stringToUnsignedInteger(str1);
          final result2 = inputConverter.stringToUnsignedInteger(str2);
          // assert
          expect(result, Left(InvalidInputFailure()));
          expect(result1, Left(InvalidInputFailure()));
          expect(result2, Left(InvalidInputFailure()));
        });

    test('should return a Failure when the string is a negative integer',
            () async {
          // arrange
          const str = "-123";
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, Left(InvalidInputFailure()));
        });

  });
}