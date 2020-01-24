import 'package:meta/meta.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    @required String username,
    @required String name,
    @required String email,
    @required List<String> role,
    @required String token,
    @required String type,
  }) : super(
            username: username,
            name: name,
            email: email,
            role: role,
            token: token,
            type: type);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      type: json['type'],
      token: json['token'],
      role: (json['role'] == null) ? json['role'] : json['role'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'type': type,
      'token': token,
      'role': role,
    };
  }
}
