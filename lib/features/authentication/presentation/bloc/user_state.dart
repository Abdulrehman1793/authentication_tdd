import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserState extends Equatable {
  UserState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends UserState {}

class Loading extends UserState {}

class Loaded extends UserState {
  final User user;

  Loaded({@required this.user}) : super([user]);
}

class Error extends UserState {
  final String message;

  Error({@required this.message}) : super([message]);
}
