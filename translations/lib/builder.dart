import 'dart:convert';
import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

void main() {
  final locales = {};
  for (final file
      in Directory('locales').listSync().map((entry) => File(entry.path))) {
    final localeName = file.path.split('/').last.split('.').first;
    final data = json.decode(file.readAsStringSync());
    locales[localeName] = data;
  }

  final emitter = DartEmitter();

  final localesList = Class(
    (b) {
      b
        ..name = 'LocalesList'
        ..docs.addAll([
          '// ignore: avoid_classes_with_only_static_members',
          '/// LocalesList class',
          '/// contains all locales',
        ])
        ..fields.add(Field(
          (b) => b
            ..name = 'locales'
            ..type = refer('List<String>')
            ..static = true
            ..modifier = FieldModifier.final$
            ..assignment =
                Code(json.encode(locales.keys.toList()).replaceAll('"', "'"))
            ..docs.add('// ignore: public_member_api_docs'),
        ));
    },
  );
  final formattedLocalesList =
      DartFormatter().format('${localesList.accept(emitter)}');
  File('lib/translation_locales_list.dart')
      .writeAsStringSync(formattedLocalesList);

  final translationMap = Class(
    (b) {
      b
        ..name = 'TranslationMap'
        ..docs.addAll([
          '// ignore_for_file: lines_longer_than_80_chars',
          '// ignore: avoid_classes_with_only_static_members',
          '/// TranslationMap class',
          '/// contains all translations in their locales',
        ])
        ..fields.add(Field(
          (b) => b
            ..name = 'translations'
            ..type = refer('Map<String,dynamic>')
            ..static = true
            ..modifier = FieldModifier.final$
            ..assignment = Code(json.encode(locales).replaceAll('"', "'"))
            ..docs.add('// ignore: public_member_api_docs'),
        ));
    },
  );
  final formattedTranslationMap =
      DartFormatter().format('${translationMap.accept(emitter)}');
  File('lib/translation_map.dart').writeAsStringSync(formattedTranslationMap);

  final appTranslations = Library(
    (b) => b
      ..body.addAll([
        Class(
          (b) {
            b
              ..name = 'AppTranslations'
              ..docs.addAll([
                '/// AppTranslations class',
                '/// handles translation for the app'
              ])
              ..constructors.add(Constructor(
                (b) => b
                  ..docs.add('// ignore: public_member_api_docs')
                  ..requiredParameters.add(Parameter(
                    (b) => b..name = 'this.locale',
                  )),
              ))
              ..fields.add(Field(
                (b) => b
                  ..name = 'locale'
                  ..type = refer('Locale')
                  ..modifier = FieldModifier.final$
                  ..docs.add('// ignore: public_member_api_docs'),
              ))
              ..methods.add(Method(
                (b) => b
                  ..name = 'of'
                  ..returns = refer('AppTranslations')
                  ..static = true
                  ..requiredParameters.add(Parameter(
                    (b) => b
                      ..name = 'context'
                      ..type = refer('BuildContext'),
                  ))
                  ..lambda = true
                  ..body = Code(
                      // ignore: lines_longer_than_80_chars
                      'Localizations.of<AppTranslations>(context, AppTranslations)')
                  ..docs.add('// ignore: public_member_api_docs'),
              ));
            locales['de'].keys.forEach((key) => b.methods.add(Method(
                  (b) => b
                    ..name = key
                    ..type = MethodType.getter
                    ..returns = locales['de'][key] is List
                        ? refer('List<String>')
                        : locales['de'][key] is Map
                            ? refer('Map<String, String>')
                            : refer('String')
                    ..lambda = true
                    ..body = Code(
                      // ignore: lines_longer_than_80_chars
                      "TranslationMap.translations[locale.languageCode]['$key']",
                    )
                    ..docs.add('// ignore: public_member_api_docs'),
                )));
            b.methods.add(Method(
              (b) => b
                ..name = 'byKey'
                ..returns = refer('dynamic')
                ..lambda = true
                ..requiredParameters.add(Parameter(
                  (b) => b
                    ..name = 'key'
                    ..type = refer('String'),
                ))
                ..body = Code(
                  'TranslationMap.translations[locale.languageCode][key]',
                )
                ..docs.add('// ignore: public_member_api_docs'),
            ));
          },
        ),
        Class(
          (b) => b
            ..name = 'AppTranslationsDelegate'
            ..docs.addAll([
              '/// AppTranslationsDelegate class',
              '/// delegate for the app translations',
            ])
            ..extend = refer('LocalizationsDelegate<AppTranslations>')
            ..methods.addAll([
              Method(
                (b) => b
                  ..name = 'isSupported'
                  ..returns = refer('bool')
                  ..annotations.add(refer('override'))
                  ..requiredParameters.add(Parameter(
                    (b) => b
                      ..name = 'locale'
                      ..type = refer('Locale'),
                  ))
                  ..lambda = true
                  ..body = Code(
                      // ignore: lines_longer_than_80_chars
                      '${json.encode(locales.keys.toList()).replaceAll('"', "'")}.contains(locale.languageCode)'),
              ),
              Method(
                (b) => b
                  ..name = 'load'
                  ..returns = refer('Future<AppTranslations>')
                  ..annotations.add(refer('override'))
                  ..requiredParameters.add(Parameter(
                    (b) => b
                      ..name = 'locale'
                      ..type = refer('Locale'),
                  ))
                  ..lambda = true
                  ..body = Code('AppTranslations(locale)')
                  ..modifier = MethodModifier.async,
              ),
              Method(
                (b) => b
                  ..name = 'shouldReload'
                  ..returns = refer('bool')
                  ..annotations.add(refer('override'))
                  ..requiredParameters.add(Parameter(
                    (b) => b
                      ..name = 'old'
                      ..type = refer('AppTranslationsDelegate'),
                  ))
                  ..lambda = true
                  ..body = Code('false'),
              ),
            ]),
        ),
      ])
      ..directives.addAll([
        Directive.import('package:flutter/material.dart'),
        Directive.import('package:translations/translation_map.dart'),
      ]),
  );
  final formattedAppTranslations =
      DartFormatter().format('${appTranslations.accept(emitter)}');
  const rules =
      '// ignore_for_file: lines_longer_than_80_chars, uri_does_not_exist, undefined_class, extends_non_class, undefined_identifier, override_on_non_overriding_method, public_member_api_docs';
  File('lib/translations_app.dart')
      .writeAsStringSync('$rules\n$formattedAppTranslations');

  final serverTranslations = Library(
    (b) => b
      ..body.addAll([
        Class((b) {
          b
            ..name = 'ServerTranslations'
            ..docs.addAll([
              '/// ServerTranslations class',
              '/// handles translation for the server',
              '// ignore: lines_longer_than_80_chars',
              '/// You have to pass the locale every time, because the server rarely needs the translations'
            ]);
          locales['de'].keys.forEach((key) => b.methods.add(Method(
                (b) => b
                  ..name = key
                  ..returns = locales['de'][key] is List
                      ? refer('List<String>')
                      : locales['de'][key] is Map
                          ? refer('Map<String, String>')
                          : refer('String')
                  ..lambda = true
                  ..static = true
                  ..requiredParameters.add(Parameter(
                    (b) => b
                      ..name = 'locale'
                      ..type = refer('String'),
                  ))
                  ..body = Code(
                    // ignore: lines_longer_than_80_chars
                    "TranslationMap.translations[locale]['$key']",
                  )
                  ..docs.add('// ignore: public_member_api_docs'),
              )));
          b.methods.add(Method(
            (b) => b
              ..name = 'byKey'
              ..returns = refer('dynamic')
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (b) => b
                    ..name = 'locale'
                    ..type = refer('String'),
                ),
                Parameter(
                  (b) => b
                    ..name = 'key'
                    ..type = refer('String'),
                ),
              ])
              ..body = Code(
                'TranslationMap.translations[locale][key]',
              )
              ..docs.add('// ignore: public_member_api_docs'),
          ));
        })
      ])
      ..directives.addAll([
        Directive.import('package:translations/translation_map.dart'),
      ]),
  );
  final formattedServerTranslations =
      DartFormatter().format('${serverTranslations.accept(emitter)}');
  File('lib/translations_server.dart')
      .writeAsStringSync(formattedServerTranslations);
}
