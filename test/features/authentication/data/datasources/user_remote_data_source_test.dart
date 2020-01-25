import 'dart:convert';

import 'package:authentication_tdd/core/error/exception.dart';
import 'package:authentication_tdd/features/authentication/data/datasources/user_remote_data_source.dart';
import 'package:authentication_tdd/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  UserRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer(
      (_) async => http.Response(fixture('user.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('signin', () {
    final usernameOrEmail = "abdulrehman1793@gmail.com";
    final password = "123456";

    final userModel = UserModel.fromJson(json.decode(fixture('user.json')));

    test(
      'should preform a POST request on a URL with number being the endpoint and with application/json header',
      () {
        //arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.signin(usernameOrEmail, password);
        // assert
        verify(mockHttpClient.post(
          'http://localhost:5000/api/auth/signin',
          headers: {'Content-Type': 'application/json'},
          body: {'usernameOrEmail': usernameOrEmail, 'password': password},
        ));
      },
    );

    test(
      'should return User when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.signin(usernameOrEmail, password);
        // assert
        expect(result, equals(userModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.signin;
        // assert
        expect(() => call(usernameOrEmail, password),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('signup', () {
    final name = "Khan Abdulrehman";
    final username = "Abdulrehman";
    final email = "abdulrehman1793@gmail.com";
    final password = "123456";

    final userModel = UserModel.fromJson(json.decode(fixture('user.json')));

    test(
      'should preform a POST request on a URL with *random* endpoint with application/json header',
      () {
        //arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.signup(
          name: name,
          username: username,
          email: email,
          password: password,
        );
        // assert
        verify(mockHttpClient.post(
          'http://localhost:5000/api/auth/signup',
          headers: {'Content-Type': 'application/json'},
          body: {
            'username': username,
            'name': name,
            'email': email,
            'password': password
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.signup(
          name: name,
          username: username,
          email: email,
          password: password,
        );
        // assert
        expect(result, equals(userModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.signup;
        // assert
        expect(
            () => call(
                  name: name,
                  username: username,
                  email: email,
                  password: password,
                ),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
