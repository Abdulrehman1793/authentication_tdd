import 'dart:convert';

import 'package:authentication_tdd/core/error/exception.dart';
import 'package:authentication_tdd/features/authentication/data/datasources/user_local_data_source.dart';
import 'package:authentication_tdd/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  UserLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = UserLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastUser', () {
    final userModel =
        UserModel.fromJson(json.decode(fixture('user_cached.json')));

    test(
      'should return User from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('user_cached.json'));
        // act
        final result = await dataSource.getUser();
        // assert
        verify(mockSharedPreferences.getString(CACHED_USER));
        expect(result, equals(userModel));
      },
    );

    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      // Not calling the method here, just storing it inside a call variable
      final call = dataSource.getUser;
      // assert
      // Calling the method happens from a higher-order function passed.
      // This is needed to test if calling a method throws an exception.
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheUser', () {
    final userModel = UserModel(
      name: "Khan Abdulrehman",
      email: "abdulrehman1793@gmail.com",
      username: "abdulrehman1793",
      role: null,
      token:
          "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
      type: "Bearer",
    );

    test('should call SharedPreferences to cache the data', () {
      // act
      dataSource.cacheUser(userModel);
      // assert
      final expectedJsonString = json.encode(userModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_USER,
        expectedJsonString,
      ));
    });
  });
}
