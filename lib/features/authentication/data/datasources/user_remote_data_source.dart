import 'dart:convert';

import 'package:authentication_tdd/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> signin(String usernameOrEmail, String password);

  Future<UserModel> signup(
      {String username, String name, String email, String password});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({@required this.client});

  @override
  Future<UserModel> signin(String usernameOrEmail, String password) =>
      _getUserFromUrl('http://localhost:5000/api/auth/signin',
          {'usernameOrEmail': usernameOrEmail, 'password': password});

  @override
  Future<UserModel> signup(
          {String username, String name, String email, String password}) =>
      _getUserFromUrl('http://localhost:5000/api/auth/signup', {
        'username': username,
        'name': name,
        'email': email,
        'password': password
      });

  Future<UserModel> _getUserFromUrl(String url, dynamic body) async {
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
