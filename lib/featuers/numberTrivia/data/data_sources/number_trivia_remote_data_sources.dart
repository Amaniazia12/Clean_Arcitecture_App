import 'dart:convert';

import 'package:architecture/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:architecture/featuers/numberTrivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemotDataSources {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemotDataSourcesImpl implements NumberTriviaRemotDataSources {
  final http.Client client;

  NumberTriviaRemotDataSourcesImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl(Uri.parse('http://numbersapi.com/$number'));

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl(Uri.parse('http://numbersapi.com/random'));

  Future<NumberTriviaModel> _getTriviaFromUrl(Uri url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
