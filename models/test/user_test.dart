import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('Can create user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'ef',
      );
      expect(user.username, 'jandoe');
      expect(user.password, 'abc');
      expect(user.grade, 'ef');
    });

    test('Can create user from JSON', () {
      final user = User.fromJSON({
        'username': 'jandoe',
        'password': 'abc',
        'grade': 'ef',
      });
      expect(user.username, 'jandoe');
      expect(user.password, 'abc');
      expect(user.grade, 'ef');
    });

    test('Can create JSON from user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'ef',
      );
      expect(
        user.toJSON(),
        {
          'username': 'jandoe',
          'password': 'abc',
          'grade': 'ef',
        },
      );
    });

    test('Can create safe JSON from user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'ef',
      );
      expect(
        user.toSafeJSON(),
        {
          'username': 'jandoe',
          'password': sha256.convert(utf8.encode('abc')).toString(),
          'grade': 'ef',
        },
      );
    });

    test('Can create user from JSON from user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'ef',
      );
      expect(User.fromJSON(user.toJSON()).toJSON(), user.toJSON());
    });
  });
}
