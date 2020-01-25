import 'dart:async';

import 'package:authentication_tdd/core/error/failures.dart';
import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';
import 'package:authentication_tdd/features/authentication/domain/usecases/signin.dart'
    as si;
import 'package:authentication_tdd/features/authentication/domain/usecases/signup.dart'
    as su;
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class UserBloc extends Bloc<UserEvent, UserState> {
  final si.Signin signinUsecase;
  final su.Signup signupUsecase;

  UserBloc({
    // Changed the name of the constructor parameter (cannot use 'this.')
    @required si.Signin signinUC,
    @required su.Signup signupUC,
    // Asserts are how you can make sure that a passed in argument is not null.
    // We omit this elsewhere for the sake of brevity.
  })  : assert(signinUC != null),
        assert(signupUC != null),
        signinUsecase = signinUC,
        signupUsecase = signupUC;

  @override
  UserState get initialState => Empty();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SigninEvent) {
      yield Loading();
      final failureOrTrivia = await signinUsecase(si.Params(
          usernameOrEmail: event.usernameOrEmail, password: event.password));
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    } else if (event is SignupEvent) {
      yield Loading();
      final failureOrTrivia = await signupUsecase(su.Params(
          name: event.name,
          username: event.username,
          email: event.email,
          password: event.password));
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<UserState> _eitherLoadedOrErrorState(
    Either<Failure, User> failureOrUser,
  ) async* {
    yield failureOrUser.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (user) => Loaded(user: user),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
