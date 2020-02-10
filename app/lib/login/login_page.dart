import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/utils/custom_button.dart';
import 'package:ginko/utils/custom_circular_progress_indicator.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';

// ignore: public_member_api_docs
class _LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final FocusNode _passwordFieldFocus = FocusNode();
  final FocusNode _submitButtonFocus = FocusNode();
  final TextEditingController _usernameFieldController =
      TextEditingController();
  final TextEditingController _passwordFieldController =
      TextEditingController();

  bool _checkingLogin = false;

  Future _submitLogin() async {
    try {
      if (_usernameFieldController.text.isEmpty ||
          _passwordFieldController.text.isEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Username und Passwort erforderlich'),
        ));
        return;
      }
      setState(() {
        _checkingLogin = true;
      });
      final credentialsCorrect = await Static.user.forceLoadOnline(
        _usernameFieldController.text,
        _passwordFieldController.text,
      );
      setState(() {
        _checkingLogin = false;
      });
      if (credentialsCorrect) {
        await Navigator.of(context).pushReplacementNamed('/');
        return;
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Die Anmeldedaten sind falsch'),
        ));
        _passwordFieldController.clear();
        FocusScope.of(context).requestFocus(_passwordFieldFocus);
      }
    } on DioError {
      setState(() {
        _checkingLogin = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Deine Anmeldung konnte nicht überprüft werden'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      obscureText: false,
      enabled: !_checkingLogin,
      decoration: InputDecoration(
        hintText: 'Username',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).accentColor,
            width: 2,
          ),
        ),
      ),
      controller: _usernameFieldController,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFieldFocus);
      },
    );
    final passwordField = TextField(
      obscureText: true,
      enabled: !_checkingLogin,
      decoration: InputDecoration(
        hintText: 'Passwort',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).accentColor,
            width: 2,
          ),
        ),
      ),
      controller: _passwordFieldController,
      focusNode: _passwordFieldFocus,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_submitButtonFocus);
        _submitLogin();
      },
    );
    final submitButton = Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: CustomButton(
        focusNode: _submitButtonFocus,
        onPressed: _submitLogin,
        child: _checkingLogin
            ? CustomCircularProgressIndicator(
                height: 25,
                width: 25,
                color: Theme.of(context).primaryColor,
              )
            : Text('Anmelden'),
      ),
    );
    return Center(
      child: Scrollbar(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            SizeLimit(
              child: Column(
                children: [
                  usernameField,
                  passwordField,
                  submitButton,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: public_member_api_docs
class LoginPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: _LoginPage(),
      );
}
