import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class Signup extends UseCase<User, Params> {
  final UserRepository repository;

  Signup(this.repository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await repository.signup(
      name: params.name,
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class Params extends Equatable {
  final String name;
  final String username;
  final String email;
  final String password;

  Params({
    @required this.name,
    @required this.username,
    @required this.email,
    @required this.password,
  }) : super([name, username, email, password]);
}
