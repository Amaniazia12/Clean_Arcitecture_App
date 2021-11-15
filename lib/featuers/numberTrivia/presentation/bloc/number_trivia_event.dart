part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTriviaForConcrateNumber extends NumberTriviaEvent {
  final String numberString;
  GetTriviaForConcrateNumber(this.numberString);
}

// ignore: must_be_immutable
class GetTriviaForRandomNumber extends NumberTriviaEvent {}
