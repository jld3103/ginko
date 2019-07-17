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
        grade: 'EF',
        language: 'de',
        selection: {'a': 'b'},
        tokens: ['c'],
      );
      expect(user.username, 'jandoe');
      expect(
        user.encryptedUsername,
        sha256.convert(utf8.encode('jandoe')).toString(),
      );
      expect(user.password, 'abc');
      expect(
        user.encryptedPassword,
        sha256.convert(utf8.encode('abc')).toString(),
      );
      expect(user.grade, 'EF');
      expect(user.language, 'de');
      expect(user.selection, {'a': 'b'});
      expect(user.tokens, ['c']);
    });

    test('Can create user without selection and tokens', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'EF',
        language: 'de',
        selection: null,
        tokens: null,
      );
      expect(user.username, 'jandoe');
      expect(
        user.encryptedUsername,
        sha256.convert(utf8.encode('jandoe')).toString(),
      );
      expect(user.password, 'abc');
      expect(
        user.encryptedPassword,
        sha256.convert(utf8.encode('abc')).toString(),
      );
      expect(user.grade, 'EF');
      expect(user.language, 'de');
      expect(user.selection, {});
      expect(user.tokens, []);
    });

    test('Can create user from JSON without selection and tokens', () {
      final user = User.fromJSON({
        'username': 'jandoe',
        'password': 'abc',
        'grade': 'EF',
        'language': 'de',
      });
      expect(user.username, 'jandoe');
      expect(
        user.encryptedUsername,
        sha256.convert(utf8.encode('jandoe')).toString(),
      );
      expect(user.password, 'abc');
      expect(
        user.encryptedPassword,
        sha256.convert(utf8.encode('abc')).toString(),
      );
      expect(user.grade, 'EF');
      expect(user.language, 'de');
      expect(user.selection, {});
      expect(user.tokens, []);
    });

    test('Can create user from JSON', () {
      final user = User.fromJSON({
        'username': 'jandoe',
        'password': 'abc',
        'grade': 'EF',
        'language': 'de',
        'selection': {'a': 'b'},
        'tokens': ['c'],
      });
      expect(user.username, 'jandoe');
      expect(
        user.encryptedUsername,
        sha256.convert(utf8.encode('jandoe')).toString(),
      );
      expect(user.password, 'abc');
      expect(
        user.encryptedPassword,
        sha256.convert(utf8.encode('abc')).toString(),
      );
      expect(user.grade, 'EF');
      expect(user.language, 'de');
      expect(user.selection, {'a': 'b'});
      expect(user.tokens, ['c']);
    });

    test('Can create JSON from user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'EF',
        language: 'de',
        selection: {'a': 'b'},
        tokens: ['c'],
      );
      expect(
        user.toJSON(),
        {
          'username': 'jandoe',
          'password': 'abc',
          'grade': 'EF',
          'language': 'de',
          'selection': {'a': 'b'},
          'tokens': ['c'],
        },
      );
    });

    test('Can create encrypted JSON from user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'EF',
        language: 'de',
        selection: {'a': 'b'},
        tokens: ['c'],
      );
      expect(
        user.toEncryptedJSON(),
        {
          'username': sha256.convert(utf8.encode('jandoe')).toString(),
          'password': sha256.convert(utf8.encode('abc')).toString(),
          'grade': 'EF',
          'language': 'de',
          'selection': {'a': 'b'},
          'tokens': ['c'],
        },
      );
    });

    test('Can create changed from JSON from changed', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'EF',
        language: 'de',
        selection: {'a': 'b'},
        tokens: ['c'],
      );
      expect(User.fromJSON(user.toJSON()).toJSON(), user.toJSON());
    });

    test('Can get selection', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'EF',
        language: 'de',
        selection: {'a': 'b'},
        tokens: ['c'],
      );
      expect(user.getSelection('a'), 'b');
    });

    test('Can set selection', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: 'EF',
        language: 'de',
        selection: {'a': 'b'},
        tokens: ['c'],
      );
      expect(user.getSelection('a'), 'b');
      user.setSelection('a', 'c');
      expect(user.getSelection('a'), 'c');
    });
  });
}
