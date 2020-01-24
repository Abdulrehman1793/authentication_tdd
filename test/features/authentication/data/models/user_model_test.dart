import 'dart:convert';

import 'package:authentication_tdd/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_tdd/features/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final userModel = UserModel(
    name: "Khan Abdulrehman",
    email: "abdulrehman1793@gmail.com",
    username: "abdulrehman1793",
    role: ["User"],
    token:
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
    type: "Bearer",
  );

  final userMultiRoleModel = UserModel(
    name: "Khan Abdulrehman",
    email: "abdulrehman1793@gmail.com",
    username: "abdulrehman1793",
    role: ["User", "Admin"],
    token:
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
    type: "Bearer",
  );

  final userNoRoleModel = UserModel(
    name: "Khan Abdulrehman",
    email: "abdulrehman1793@gmail.com",
    username: "abdulrehman1793",
    role: null,
    token:
        "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
    type: "Bearer",
  );

  test(
    'should be a subclass of User entity',
    () async {
      // assert
      expect(userModel, isA<User>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON role is defined.',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result, userModel);
      },
    );

    test(
      'should return a valid model when the JSON role is undefined.',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user_without_role.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result.role, null);
      },
    );
  });

  group('toJson-should return a JSON map containing the proper data', () {
    test(
      'Single role',
      () async {
        // act
        final result = userModel.toJson();

        // assert
        final expectedMap = {
          "name": "Khan Abdulrehman",
          "email": "abdulrehman1793@gmail.com",
          "username": "abdulrehman1793",
          "role": ["User"],
          "token":
              "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
          "type": "Bearer",
        };
        expect(result, expectedMap);
      },
    );

    test(
      'Multiple role',
      () async {
        // act
        final result = userMultiRoleModel.toJson();

        // assert
        final expectedMap = {
          "name": "Khan Abdulrehman",
          "email": "abdulrehman1793@gmail.com",
          "username": "abdulrehman1793",
          "role": ['User', 'Admin'],
          "token":
              "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
          "type": "Bearer",
        };
        expect(result, expectedMap);
      },
    );

    test(
      'No Role',
      () async {
        // act
        final result = userNoRoleModel.toJson();

        // assert
        final expectedMap = {
          "name": "Khan Abdulrehman",
          "email": "abdulrehman1793@gmail.com",
          "username": "abdulrehman1793",
          "role": null,
          "token":
              "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNTc5NTA0MzI1LCJleHAiOjE1ODAxMDkxMjV9.ceiQwaIaVAOxp2NXRowl_RQ5Qtq3wqQkbK0zBswuIFIS2t_Rr7e_T8JJZbOKIO0zNfZkUar__1bWqCac0DNcnQ",
          "type": "Bearer",
        };
        expect(result, expectedMap);
      },
    );
  });
}
