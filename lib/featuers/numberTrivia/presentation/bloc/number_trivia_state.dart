part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({required this.numberTrivia});

  @override
  List<Object> get props => [numberTrivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
