import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const <dynamic>[]]) : super(props);
}

class SigninEvent extends UserEvent {
  final String usernameOrEmail;
  final String password;

  SigninEvent({this.usernameOrEmail, this.password})
      : super([usernameOrEmail, password]);
}

class SignupEvent extends UserEvent {
  final String name;
  final String username;
  final String email;
  final String password;

  SignupEvent({this.name, this.username, this.password, this.email})
      : super([name, username, email, password]);
}
