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
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
        selection: [UserValue('a', 'b', DateTime(2019, 8, 6, 22, 6, 11))],
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
      expect(
        user.grade.toJSON(),
        {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.language.toJSON(),
        {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.selection.map((i) => i.toJSON()).toList(),
        [
          {
            'key': 'a',
            'value': 'b',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          }
        ],
      );
      expect(user.tokens, ['c']);
    });

    test('Can create user without selection and tokens', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
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
      expect(
        user.grade.toJSON(),
        {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.language.toJSON(),
        {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(user.selection.map((i) => i.toJSON()).toList(), []);
      expect(user.tokens, []);
    });

    test('Can create user from JSON without selection and tokens', () {
      final user = User.fromJSON({
        'username': 'jandoe',
        'password': 'abc',
        'grade': {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
        'language': {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
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
      expect(
        user.grade.toJSON(),
        {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.language.toJSON(),
        {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(user.selection.map((i) => i.toJSON()).toList(), []);
      expect(user.tokens, []);
    });

    test('Can create user from JSON', () {
      final user = User.fromJSON({
        'username': 'jandoe',
        'password': 'abc',
        'grade': {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
        'language': {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
        'selection': [
          {
            'key': 'a',
            'value': 'b',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          }
        ],
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
      expect(
        user.grade.toJSON(),
        {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.language.toJSON(),
        {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.selection.map((i) => i.toJSON()).toList(),
        [
          {
            'key': 'a',
            'value': 'b',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          }
        ],
      );
      expect(user.tokens, ['c']);
    });

    test('Can create user from encrypted JSON without selection and tokens',
        () {
      final user = User.fromEncryptedJSON(
        {
          'grade': {
            'key': 'grade',
            'value': 'EF',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
          'language': {
            'key': 'language',
            'value': 'de',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
        },
        'jandoe',
        'abc',
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
      expect(
        user.grade.toJSON(),
        {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.language.toJSON(),
        {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(user.selection.map((i) => i.toJSON()).toList(), []);
      expect(user.tokens, []);
    });

    test('Can create user from encrypted JSON', () {
      final user = User.fromEncryptedJSON(
        {
          'grade': {
            'key': 'grade',
            'value': 'EF',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
          'language': {
            'key': 'language',
            'value': 'de',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
          'selection': [
            {
              'key': 'a',
              'value': 'b',
              'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
            }
          ],
          'tokens': ['c'],
        },
        'jandoe',
        'abc',
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
      expect(
        user.grade.toJSON(),
        {
          'key': 'grade',
          'value': 'EF',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.language.toJSON(),
        {
          'key': 'language',
          'value': 'de',
          'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
        },
      );
      expect(
        user.selection.map((i) => i.toJSON()).toList(),
        [
          {
            'key': 'a',
            'value': 'b',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          }
        ],
      );
      expect(user.tokens, ['c']);
    });

    test('Can create JSON from user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
        selection: [UserValue('a', 'b', DateTime(2019, 8, 6, 22, 6, 11))],
        tokens: ['c'],
      );
      expect(
        user.toJSON(),
        {
          'username': 'jandoe',
          'password': 'abc',
          'grade': {
            'key': 'grade',
            'value': 'EF',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
          'language': {
            'key': 'language',
            'value': 'de',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
          'selection': [
            {
              'key': 'a',
              'value': 'b',
              'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
            }
          ],
          'tokens': ['c'],
        },
      );
    });

    test('Can create encrypted JSON from user', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
        selection: [UserValue('a', 'b', DateTime(2019, 8, 6, 22, 6, 11))],
        tokens: ['c'],
      );
      expect(
        user.toEncryptedJSON(),
        {
          'username': sha256.convert(utf8.encode('jandoe')).toString(),
          'password': sha256.convert(utf8.encode('abc')).toString(),
          'grade': {
            'key': 'grade',
            'value': 'EF',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
          'language': {
            'key': 'language',
            'value': 'de',
            'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
          },
          'selection': [
            {
              'key': 'a',
              'value': 'b',
              'modified': DateTime(2019, 8, 6, 22, 6, 11).toIso8601String(),
            }
          ],
          'tokens': ['c'],
        },
      );
    });

    test('Can create changed from JSON from changed', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
        selection: [UserValue('a', 'b', DateTime(2019, 8, 6, 22, 6, 11))],
        tokens: ['c'],
      );
      expect(User.fromJSON(user.toJSON()).toJSON(), user.toJSON());
    });

    test('Can get selection', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
        selection: [UserValue('a', 'b', DateTime(2019, 8, 6, 22, 6, 11))],
        tokens: ['c'],
      );
      expect(user.getSelection('a'), 'b');
    });

    test('Can set selection', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
        selection: [UserValue('a', 'b', DateTime(2019, 8, 6, 22, 6, 11))],
        tokens: ['c'],
      );
      expect(user.getSelection('a'), 'b');
      user.setSelection('a', 'c');
      expect(user.getSelection('a'), 'c');
    });

    test('Can add selection', () {
      final user = User(
        username: 'jandoe',
        password: 'abc',
        grade: UserValue('grade', 'EF', DateTime(2019, 8, 6, 22, 6, 11)),
        language: UserValue('language', 'de', DateTime(2019, 8, 6, 22, 6, 11)),
        selection: [],
        tokens: ['c'],
      );
      expect(user.getSelection('a'), null);
      user.setSelection('a', 'c');
      expect(user.getSelection('a'), 'c');
    });

    test('Can create user value', () {
      final userValue = UserValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(userValue.key, 'a');
      expect(userValue.value, 'b');
      expect(userValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create user value without explicit modified stamp', () {
      final userValue = UserValue('a', 'b');
      expect(userValue.key, 'a');
      expect(userValue.value, 'b');
      expect(userValue.modified.isBefore(DateTime.now()), true);
    });

    test('Can create user value from JSON', () {
      final userValue = UserValue.fromJSON({
        'key': 'a',
        'value': 'b',
        'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
      });
      expect(userValue.key, 'a');
      expect(userValue.value, 'b');
      expect(userValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create user value from JSON without explicit modified stamp', () {
      final userValue = UserValue.fromJSON({
        'key': 'a',
        'value': 'b',
      });
      expect(userValue.key, 'a');
      expect(userValue.value, 'b');
      expect(userValue.modified.isBefore(DateTime.now()), true);
    });

    test('Can create JSON from user value', () {
      final userValue = UserValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(
        userValue.toJSON(),
        {
          'key': 'a',
          'value': 'b',
          'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
        },
      );
    });

    test('Can create user value from JSON from user value', () {
      final userValue = UserValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(
        UserValue.fromJSON(userValue.toJSON()).toJSON(),
        userValue.toJSON(),
      );
    });

    test('Can update user value', () {
      final userValue = UserValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(userValue.key, 'a');
      expect(userValue.value, 'b');
      expect(userValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
      userValue.value = 'c';
      expect(userValue.value, 'c');
      expect(userValue.modified.isBefore(DateTime.now()), true);
    });
  });
}
