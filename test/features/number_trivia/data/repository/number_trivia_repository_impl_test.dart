import 'package:architecture/core/error/exception.dart';
import 'package:architecture/core/network/network_info.dart';
import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_local_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/data/models/number_trivia_model.dart';
import 'package:architecture/featuers/numberTrivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_remote_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/data/repository/number_trivia_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:architecture/core/error/failures.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  NetworkInfo,
  NumberTriviaLocalDataSources,
  NumberTriviaRemotDataSources,
])
void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaRemotDataSources mockNumberTriviaRemotDataSources;
  late MockNumberTriviaLocalDataSources mockNumberTriviaLocalDataSources;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemotDataSources = MockNumberTriviaRemotDataSources();
    mockNumberTriviaLocalDataSources = MockNumberTriviaLocalDataSources();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      numberTriviaRemotDataSources: mockNumberTriviaRemotDataSources,
      numberTriviaLocalDataSources: mockNumberTriviaLocalDataSources,
      networkInfo: mockNetworkInfo,
    );
  });

  // void runTestsOnline(Function body) {
  //   group('device is online', () {
  //     setUp(() {
  //       when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  //     });

  //     body();
  //   });
  // }

  // void runTestsOffline(Function body) {
  //   group('device is offline', () {
  //     setUp(() {
  //       when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  //     });

  //     body();
  //   });
  // }

  group("getConcreteNumberTrivia ", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "text", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    group(
      'device is online',
      () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });
        test(
            'should return remote data when the call to remote data source is successful',
            () async {
          when(mockNumberTriviaRemotDataSources
                  .getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);

          final result =
              await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

          expect(result, equals(Right(tNumberTrivia)));
        });

        test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
          when(mockNumberTriviaRemotDataSources
                  .getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());
          final result =
              await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
          verify(mockNumberTriviaRemotDataSources
              .getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockNumberTriviaLocalDataSources);
          expect(result, equals(Left(ServerFailure())));
        });
      },
    );

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockNumberTriviaLocalDataSources
                .getLastNumberTrivia()) //el mock mat3mlosh update
            .thenAnswer((_) async => tNumberTriviaModel);
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockNumberTriviaRemotDataSources);
        verify(mockNumberTriviaLocalDataSources.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });
      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockNumberTriviaLocalDataSources.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("getRandomNumberTrivia ", () {
    final tNumberTriviaModel = NumberTriviaModel(text: "text", number: 1);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemotDataSources.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        print(result);
        verify(mockNumberTriviaRemotDataSources.getRandomNumberTrivia());

        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockNumberTriviaRemotDataSources.getRandomNumberTrivia())
            .thenThrow(ServerException());
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        verify(mockNumberTriviaRemotDataSources.getRandomNumberTrivia());

        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockNumberTriviaLocalDataSources
                .getLastNumberTrivia()) //el mock mat3mlosh update
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        //verifyZeroInteractions(mockNumberTriviaRemotDataSources);
        verify(mockNumberTriviaLocalDataSources.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });
      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockNumberTriviaLocalDataSources.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
