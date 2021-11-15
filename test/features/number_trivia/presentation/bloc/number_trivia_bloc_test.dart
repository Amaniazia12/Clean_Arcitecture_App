import 'dart:math';

import 'package:architecture/core/error/failures.dart';
import 'package:architecture/core/utils/input_converter.dart';
import 'package:architecture/featuers/numberTrivia/domain/entity/number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/domain/usecases/get_random_number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;

  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    expect(bloc.state, Empty());
  });
  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    //??
    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        when(mockInputConverter.stringTounsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        bloc.add(GetTriviaForConcrateNumber(tNumberString));
        await untilCalled(mockInputConverter.stringTounsignedInteger(any));
        verify(mockInputConverter.stringTounsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringTounsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          // The initial state is always emitted first
          // Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcrateNumber(tNumberString));
      },
    );
    group("input valid", () {
      setUp(() => when(mockInputConverter.stringTounsignedInteger(any))
          .thenReturn(Right(tNumberParsed)));
      test(
          'should emit [ loding and  Loaded number trivia ] when the use case return numbertrivia',
          () {
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        final expectedResults = [
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(GetTriviaForConcrateNumber(tNumberString));
        //verify(mockGetConcreteNumberTrivia(any));
      });
      test(
          'should emit [ loding and  Loaded number trivia ] when the use case return server failure',
          () {
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        final expectedResults = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(GetTriviaForConcrateNumber(tNumberString));
        //verify(mockGetConcreteNumberTrivia(any));
      });

      test(
          'should emit [ loding and  Loaded number trivia ] when the use case return cache failure',
          () {
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expectedResults = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(GetTriviaForConcrateNumber(tNumberString));
        //verify(mockGetConcreteNumberTrivia(any));
      });
    });
  });

  group('GetTriviaForRandomNumber', () {
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    group("input valid", () {
      test(
          'should emit [ loding and  Loaded number trivia ] when the use case return numbertrivia',
          () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        final expectedResults = [
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(GetTriviaForRandomNumber());
      });
      test(
          'should emit [ loding and  Loaded number trivia ] when the use case return server failure',
          () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        final expectedResults = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(GetTriviaForRandomNumber());
      });

      test(
          'should emit [ loding and  Loaded number trivia ] when the use case return cache failure',
          () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expectedResults = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(GetTriviaForRandomNumber());
      });
    });
  });
}
