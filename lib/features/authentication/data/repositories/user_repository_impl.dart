import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

typedef Future<User> _ConcreteOrRandomChooser();

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signin(
      String usernameOrEmail, String password) async {
    return await _getUser(() {
      return remoteDataSource.signin(usernameOrEmail, password);
    });
  }

  @override
  Future<Either<Failure, User>> signup(
      {String name, String username, String email, String password}) async {
    return await _getUser(() {
      return remoteDataSource.signup(
        name: name,
        username: username,
        email: email,
        password: password,
      );
    });
  }

  Future<Either<Failure, User>> _getUser(
    _ConcreteOrRandomChooser getSigninOrSignup,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getSigninOrSignup();
        localDataSource.cacheUser(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getUser();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
