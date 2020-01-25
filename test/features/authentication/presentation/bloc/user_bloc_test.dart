import 'package:authentication_tdd/core/error/failures.dart';
import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';
import 'package:authentication_tdd/features/authentication/domain/usecases/signin.dart'
    as si;
import 'package:authentication_tdd/features/authentication/domain/usecases/signup.dart'
    as su;
import 'package:authentication_tdd/features/authentication/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSignin extends Mock implements si.Signin {}

class MockSignup extends Mock implements su.Signup {}

void main() {
  UserBloc bloc;
  si.Signin mockSignin;
  su.Signup mockSignup;

  setUp(() {
    mockSignin = MockSignin();
    mockSignup = MockSignup();

    bloc = UserBloc(
      signinUC: mockSignin,
      signupUC: mockSignup,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('Signin', () {
    final usernameOrEmail = "abdulrehman1793@gmail.com";
    final password = "123456";
    final user = User(
      name: "Khan Abdulrehman",
      email: "abdulrehman1793@gmail.com",
      username: "abdulrehman1793",
      role: ["User"],
      token:
          "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
      type: "Bearer",
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockSignin(any)).thenAnswer((_) async => Right(user));
        // act
        bloc.add(
            SigninEvent(usernameOrEmail: usernameOrEmail, password: password));
        await untilCalled(mockSignin(any));
        // assert
        verify(mockSignin(
            si.Params(usernameOrEmail: usernameOrEmail, password: password)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockSignin(any)).thenAnswer((_) async => Right(user));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(user: user),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
            SigninEvent(usernameOrEmail: usernameOrEmail, password: password));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockSignin(any)).thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
            SigninEvent(usernameOrEmail: usernameOrEmail, password: password));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockSignin(any)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
            SigninEvent(usernameOrEmail: usernameOrEmail, password: password));
      },
    );
  });

  group('Signup', () {
    final name = "Khan Abdulrehman";
    final username = "abdulrehman1793";
    final email = "abdulrehman1793@gmail.com";
    final password = "123456";
    final user = User(
      name: "Khan Abdulrehman",
      email: "abdulrehman1793@gmail.com",
      username: "abdulrehman1793",
      role: ["User"],
      token:
          "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
      type: "Bearer",
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockSignup(any)).thenAnswer((_) async => Right(user));
        // act
        bloc.add(SignupEvent(
            name: name, username: username, email: email, password: password));
        await untilCalled(mockSignup(any));
        // assert
        verify(mockSignup(su.Params(
            name: name, username: username, email: email, password: password)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockSignup(any)).thenAnswer((_) async => Right(user));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(user: user),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SignupEvent(
            name: name, username: username, email: email, password: password));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockSignup(any)).thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SignupEvent(
            name: name, username: username, email: email, password: password));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockSignup(any)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SignupEvent(
            name: name, username: username, email: email, password: password));
      },
    );
  });
}
