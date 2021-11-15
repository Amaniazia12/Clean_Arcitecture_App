import 'dart:convert';

import 'package:architecture/core/error/exception.dart';
import 'package:architecture/featuers/numberTrivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSources {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cashedNumberTrivia(NumberTriviaModel triviaModelCashed);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourcesImpl implements NumberTriviaLocalDataSources {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourcesImpl({required this.sharedPreferences});

  @override
  Future<void> cashedNumberTrivia(NumberTriviaModel triviaModelCashed) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaModelCashed.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonStr = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonStr != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonStr)));
    } else {
      throw CacheException();
    }
  }
}
