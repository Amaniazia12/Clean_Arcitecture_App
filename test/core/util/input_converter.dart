import 'package:architecture/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        const str = '123';
        // act
        final result = inputConverter.stringTounsignedInteger(str);
        // assert
        expect(result, const Right(123));
      },
    );

    test(
      'should return a failure when the string is not an integer',
      () async {
        // arrange
        const str = 'abc';
        // act
        final result = inputConverter.stringTounsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test('should return a failure when the string is a negative integer', () {
      const str = "-123";
      final result = inputConverter.stringTounsignedInteger(str);
      expect(result, const Left(-123));
    });
  });
}
