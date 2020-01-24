import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> sigin({String usernameOrEmail, String password});

  Future<UserModel> signup(
      {String username, String name, String email, String password});
}
