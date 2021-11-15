import 'package:architecture/core/error/exception.dart';
import 'package:architecture/core/network/network_info.dart';
import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_local_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/data/data_sources/number_trivia_remote_data_sources.dart';
import 'package:architecture/featuers/numberTrivia/domain/entity/number_trivia.dart';
import 'package:architecture/core/error/failures.dart';
import 'package:architecture/featuers/numberTrivia/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaLocalDataSources numberTriviaLocalDataSources;
  NumberTriviaRemotDataSources numberTriviaRemotDataSources;
  NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.numberTriviaLocalDataSources,
    required this.numberTriviaRemotDataSources,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final remotData =
            await numberTriviaRemotDataSources.getConcreteNumberTrivia(number);
        numberTriviaLocalDataSources.cashedNumberTrivia(remotData);
        return Right(remotData);
      } on ServerException {
        return (Left(ServerFailure()));
      }
    } else {
      try {
        final localData =
            await numberTriviaLocalDataSources.getLastNumberTrivia();
        return Right(localData); //leh msh localData bs ?
      } on CacheException {
        return (Left(CacheFailure()));
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await numberTriviaRemotDataSources.getRandomNumberTrivia();
        numberTriviaLocalDataSources.cashedNumberTrivia(remoteData);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData =
            await numberTriviaLocalDataSources.getLastNumberTrivia();
        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
