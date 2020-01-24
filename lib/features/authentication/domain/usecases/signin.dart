import 'package:authentication_tdd/core/error/failures.dart';
import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../repositories/user_repository.dart';

class Signin {
  final UserRepository repository;

  Signin(this.repository);

  Future<Either<Failure, User>> execute({
    @required String usernameOrEmail,
    @required String password,
  }) async {
    return await repository.signin(usernameOrEmail, password);
  }
}
