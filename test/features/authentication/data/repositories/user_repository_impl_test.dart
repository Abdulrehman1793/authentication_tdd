import 'package:authentication_tdd/core/error/exception.dart';
import 'package:authentication_tdd/core/error/failures.dart';
import 'package:authentication_tdd/core/platform/network_info.dart';
import 'package:authentication_tdd/features/authentication/data/datasources/user_local_data_source.dart';
import 'package:authentication_tdd/features/authentication/data/datasources/user_remote_data_source.dart';
import 'package:authentication_tdd/features/authentication/data/models/user_model.dart';
import 'package:authentication_tdd/features/authentication/data/repositories/user_repository_impl.dart';
import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockLocalDataSource extends Mock implements UserLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  UserRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('signin', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these variables throughout all the tests
    final name = "Khan Abdulrehman";
    final username = "abdulrehman1793";
    final email = "abdulrehman1793@gmail.com";
    final password = "123456";

    final userModel = UserModel(
      name: "Khan Abdulrehman",
      email: "abdulrehman1793@gmail.com",
      username: "abdulrehman1793",
      role: ["User"],
      token:
          "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
      type: "Bearer",
    );
    final User user = userModel;

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.signin(email, password);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.signin(email, password))
              .thenAnswer((_) async => userModel);
          // act
          final result = await repository.signin(email, password);
          // assert
          verify(mockRemoteDataSource.signin(email, password));
          expect(result, equals(Right(user)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.signin(email, password))
              .thenAnswer((_) async => userModel);
          // act
          await repository.signin(email, password);
          // assert
          verify(mockRemoteDataSource.signin(email, password));
          verify(mockLocalDataSource.cacheUser(user));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.signin(email, password))
              .thenThrow(ServerException());
          // act
          final result = await repository.signin(email, password);
          // assert
          verify(mockRemoteDataSource.signin(email, password));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getUser())
              .thenAnswer((_) async => userModel);
          // act
          final result = await repository.signin(email, password);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getUser());
          expect(result, equals(Right(user)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getUser()).thenThrow(CacheException());
          // act
          final result = await repository.signin(email, password);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getUser());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('signup', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these variables throughout all the tests
    final name = "Khan Abdulrehman";
    final username = "abdulrehman1793";
    final email = "abdulrehman1793@gmail.com";
    final password = "123456";

    final userModel = UserModel(
      name: "Khan Abdulrehman",
      email: "abdulrehman1793@gmail.com",
      username: "abdulrehman1793",
      role: ["User"],
      token:
          "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
      type: "Bearer",
    );
    final User user = userModel;

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.signup(
        name: name,
        username: username,
        email: email,
        password: password,
      );
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          )).thenAnswer((_) async => userModel);
          // act
          final result = await repository.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          );
          // assert
          verify(mockRemoteDataSource.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          ));
          expect(result, equals(Right(user)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          )).thenAnswer((_) async => userModel);
          // act
          await repository.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          );
          // assert
          verify(mockRemoteDataSource.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          ));
          verify(mockLocalDataSource.cacheUser(user));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          )).thenThrow(ServerException());
          // act
          final result = await repository.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          );
          // assert
          verify(mockRemoteDataSource.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          ));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getUser())
              .thenAnswer((_) async => userModel);
          // act
          final result = await repository.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          );
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getUser());
          expect(result, equals(Right(user)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getUser()).thenThrow(CacheException());
          // act
          final result = await repository.signup(
            name: name,
            username: username,
            email: email,
            password: password,
          );
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getUser());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
