import 'dart:convert';

import 'package:authentication_tdd/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

import '../models/user_model.dart';

const CACHED_USER = 'CACHED_USER';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<UserModel> getUser();

  Future<void> cacheUser(UserModel userToCache);
}

class UserLocalDataSourceImpl extends UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel userToCache) {
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<UserModel> getUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
