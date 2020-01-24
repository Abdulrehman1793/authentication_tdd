import 'package:authentication_tdd/core/error/failures.dart';
import 'package:authentication_tdd/core/usecases/usecase.dart';
import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../repositories/user_repository.dart';

class Signin extends UseCase<User, Params> {
  final UserRepository repository;

  Signin(this.repository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await repository.signin(params.usernameOrEmail, params.password);
  }
}

class Params extends Equatable {
  final String usernameOrEmail;
  final String password;

  Params({
    @required this.usernameOrEmail,
    @required this.password,
  }) : super([usernameOrEmail, password]);
}
