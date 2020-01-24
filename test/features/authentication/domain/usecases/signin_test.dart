import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';
import 'package:authentication_tdd/features/authentication/domain/repositories/user_repository.dart';
import 'package:authentication_tdd/features/authentication/domain/usecases/signin.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  Signin usecase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = Signin(mockUserRepository);
  });

  final usernameOrEmail = "abdulrehman1793@gmail.com";
  final password = "123456";
  final user = User(
      name: "Khan Abdulrehman",
      email: "abdulrehman1793@gmail.com",
      username: "abdulrehman1793",
      role: ["User"],
      token:
          "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
      type: "Bearer");

  test(
    'should get user for the credentials from the repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mockUserRepository.signin(any, any))
          .thenAnswer((_) async => Right(user));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase.execute(
          usernameOrEmail: usernameOrEmail, password: password);
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(user));
      // Verify that the method has been called on the Repository
      verify(mockUserRepository.signin(usernameOrEmail, password));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
