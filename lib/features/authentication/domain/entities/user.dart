import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String username;
  final String name;
  final String email;
  final List<String> role;

  //We use jwt authentication.
  // Access token
  final String token;
  //Token type
  final String type;

  User({
    @required this.username,
    @required this.name,
    @required this.email,
    @required this.role,
    @required this.token,
    @required this.type,
  }) : super([username, name, email, role, token, type]);
}
