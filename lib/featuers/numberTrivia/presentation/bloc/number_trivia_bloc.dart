import 'package:architecture/core/error/failures.dart';
import 'package:architecture/core/usecases/usecase.dart';
import 'package:architecture/core/utils/input_converter.dart';
import 'package:architecture/featuers/numberTrivia/domain/entity/number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/domain/usecases/get_random_number_trivia.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.inputConverter,
      required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia})
      : super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcrateNumber) {
      final inputEither =
          inputConverter.stringTounsignedInteger(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        // Although the "success case" doesn't interest us with the current test,
        // we still have to handle it somehow.

        (integer) async* {
          yield Loading();
          final result = await getConcreteNumberTrivia(Params(number: integer));
          yield* result.fold((falure) async* {
            yield Error(message: _mapFailureToMessage(falure));
          }, (numberTrivia) async* {
            yield Loaded(numberTrivia: numberTrivia);
          });
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final result = await getRandomNumberTrivia(NoParams());
      yield* result.fold((falure) async* {
        yield Error(message: _mapFailureToMessage(falure));
      }, (numberTrivia) async* {
        yield Loaded(numberTrivia: numberTrivia);
      });
    }
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
