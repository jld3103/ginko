import 'dart:io';

// ignore: avoid_classes_with_only_static_members
/// Path class
/// handles paths for relative execution locations
class Path {
  /// Get the base path of the project
  static String get getBasePath {
    final path = Directory.current.path.split('/')
      ..remove('app')
      ..remove('models')
      ..remove('server')
      ..remove('tests')
      ..remove('test');
    return '${path.join('/')}/';
  }
}
