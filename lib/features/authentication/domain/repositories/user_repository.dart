import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signin(String usernameOrEmail, String password);
  Future<Either<Failure, User>> signup({
    String name,
    String username,
    String email,
    String password,
  });
}
