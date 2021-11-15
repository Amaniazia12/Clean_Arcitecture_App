import 'dart:convert';

import 'package:architecture/core/error/exception.dart';
import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_remote_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemotDataSourcesImpl remoteDataSource;
  late MockClient mockClient;
  setUp(() {
    mockClient = MockClient();
    remoteDataSource = NumberTriviaRemotDataSourcesImpl(client: mockClient);
  });
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () {
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        remoteDataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
        );
        // act
        final call = remoteDataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
