import '../models/user_model.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<UserModel> getUser();

  Future<void> cacheUser(UserModel userToCache);
}
