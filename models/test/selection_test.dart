import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Selection', () {
    test('Can create selection', () {
      final selection = Selection([
        SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(selection.selection.length, 1);
      expect(selection.selection[0].key, 'a');
      expect(selection.selection[0].value, 'b');
      expect(selection.selection[0].modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create selection from JSON', () {
      final selection = Selection.fromJSON([
        {
          'key': 'a',
          'value': 'b',
          'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
        }
      ]);
      expect(selection.selection.length, 1);
      expect(selection.selection[0].key, 'a');
      expect(selection.selection[0].value, 'b');
      expect(selection.selection[0].modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create JSON from selection', () {
      final selection = Selection([
        SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(
        selection.toJSON(),
        [
          {
            'key': 'a',
            'value': 'b',
            'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
          }
        ],
      );
    });

    test('Can create selection from JSON from selection', () {
      final selection = Selection([
        SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(
        Selection.fromJSON(selection.toJSON()).toJSON(),
        selection.toJSON(),
      );
    });

    test('Can get selection', () {
      final selection = Selection([
        SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(selection.getSelection('a'), 'b');
    });

    test('Can set selection', () {
      final selection = Selection([
        SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(selection.getSelection('a'), 'b');
      selection.setSelection('a', 'c');
      expect(selection.getSelection('a'), 'c');
      expect(selection.getSelection('d'), null);
      selection.setSelection('d', 'e');
      expect(selection.getSelection('d'), 'e');
    });

    test('Can create selection value', () {
      final selectionValue =
          SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(selectionValue.key, 'a');
      expect(selectionValue.value, 'b');
      expect(selectionValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create selection value without explicit modified stamp', () {
      final selectionValue = SelectionValue('a', 'b');
      expect(selectionValue.key, 'a');
      expect(selectionValue.value, 'b');
      expect(selectionValue.modified.isBefore(DateTime.now()), true);
    });

    test('Can create selection value from JSON', () {
      final selectionValue = SelectionValue.fromJSON({
        'key': 'a',
        'value': 'b',
        'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
      });
      expect(selectionValue.key, 'a');
      expect(selectionValue.value, 'b');
      expect(selectionValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create selection value from JSON without explicit modified stamp',
        () {
      final selectionValue = SelectionValue.fromJSON({
        'key': 'a',
        'value': 'b',
      });
      expect(selectionValue.key, 'a');
      expect(selectionValue.value, 'b');
      expect(selectionValue.modified.isBefore(DateTime.now()), true);
    });

    test('Can create JSON from selection value', () {
      final selectionValue =
          SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(
        selectionValue.toJSON(),
        {
          'key': 'a',
          'value': 'b',
          'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
        },
      );
    });

    test('Can create selection value from JSON from selection value', () {
      final selectionValue =
          SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(
        SelectionValue.fromJSON(selectionValue.toJSON()).toJSON(),
        selectionValue.toJSON(),
      );
    });

    test('Can update selection value', () {
      final selectionValue =
          SelectionValue('a', 'b', DateTime(2019, 8, 7, 19, 56, 11));
      expect(selectionValue.key, 'a');
      expect(selectionValue.value, 'b');
      expect(selectionValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
      selectionValue.value = 'c';
      expect(selectionValue.value, 'c');
      expect(selectionValue.modified.isBefore(DateTime.now()), true);
      expect(
        selectionValue.modified.isAfter(DateTime(2019, 8, 7, 19, 56, 11)),
        true,
      );
    });
  });
}
