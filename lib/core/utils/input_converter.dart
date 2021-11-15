import 'package:architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringTounsignedInteger(String str) {
    final num = int.parse(str);
    try {
      if (num < 0) throw FormatException();
      return Right(num);
    } on FormatException {
      throw Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
