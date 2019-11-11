import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('Can create user', () {
      final user = User(
        username: 'jandoe',
        fullName: 'john doe',
        password: 'abc',
        grade: 'EF',
      );
      expect(user.username, 'jandoe');
      expect(user.fullName, 'john doe');
      expect(user.password, 'abc');
      expect(user.grade, 'EF');
    });

    test('Can create user from JSON', () {
      final user = User.fromJSON({
        'username': 'jandoe',
        'password': 'abc',
        'grade': 'EF',
        'fullName': 'john doe',
      });
      expect(user.username, 'jandoe');
      expect(user.fullName, 'john doe');
      expect(user.password, 'abc');
      expect(user.grade, 'EF');
    });

    test('Can create JSON from user', () {
      final user = User(
        username: 'jandoe',
        fullName: 'john doe',
        password: 'abc',
        grade: 'EF',
      );
      expect(
        user.toJSON(),
        {
          'username': 'jandoe',
          'password': 'abc',
          'grade': 'EF',
          'fullName': 'john doe',
        },
      );
    });

    test('Can create safe JSON from user', () {
      final user = User(
        username: 'jandoe',
        fullName: 'john doe',
        password: 'abc',
        grade: 'EF',
      );
      expect(
        user.toSafeJSON(),
        {
          'username': 'jandoe',
          'password': sha256.convert(utf8.encode('abc')).toString(),
          'grade': 'EF',
          'fullName': 'john doe',
        },
      );
    });

    test('Can create user from JSON from user', () {
      final user = User(
        username: 'jandoe',
        fullName: 'john doe',
        password: 'abc',
        grade: 'EF',
      );
      expect(User.fromJSON(user.toJSON()).toJSON(), user.toJSON());
    });
  });
}
