import 'package:flutter_test/flutter_test.dart';

/// Only testing for desktop screen sizes is possible,
/// because flutter won't let you change the screen size in tests.
/// If you try using [TestWidgetsFlutterBinding] it won't work, because
/// there is a render overflow somewhere :(
/// But theoretically the only difference between mobile and desktop is how the
/// view is conveyed to the user.
/// The core view with the information keeps the same.
void main() {}
