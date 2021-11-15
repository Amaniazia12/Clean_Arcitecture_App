import 'dart:convert';

import 'package:architecture/core/error/exception.dart';
import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_local_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixture/fixture_reader.dart';
import '../repository/number_trivia_repository_impl_test.mocks.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourcesImpl localDataSources;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSources = NumberTriviaLocalDataSourcesImpl(
        sharedPreferences: mockSharedPreferences);
  });
  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: "test", number: 1);
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cashed.json'));
      final result = await localDataSources.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    //msh fahmas
    test('should throw a CacheException when there is not a cached value', () {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final call = localDataSources.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });
}
