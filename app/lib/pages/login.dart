import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ginko/utils/static.dart';
import 'package:translations/translations_app.dart';

/// LoginPage class
/// describes the login widget
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

/// LoginPageState class
/// describes the state of the login widget
class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _focus = FocusNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCheckingForm = false;
  bool _validInputs = true;

  Future _checkForm([a]) async {
    setState(() {
      _isCheckingForm = true;
      _validInputs = _formKey.currentState.validate();
    });
    if (_validInputs) {
      try {
        final credentialsCorrect = await Static.user.forceLoadOnline(
            _usernameController.text, _passwordController.text);
        if (credentialsCorrect) {
          await Navigator.of(context).pushReplacementNamed('/');
          return;
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(AppTranslations.of(context).loginCredentialsWrong),
          ));
          _passwordController.clear();
          FocusScope.of(context).requestFocus(_focus);
        }
      } on DioError {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(AppTranslations.of(context).loginFailed),
        ));
      }
    }
    setState(() {
      _isCheckingForm = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Container(
                height: 125,
                margin: EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset('images/logo_green.svg'),
              ),
              Center(
                child: Text(
                  AppTranslations.of(context).appName,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username input
                    TextFormField(
                      autofocus: true,
                      controller: _usernameController,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppTranslations.of(context)
                              .loginUserNameRequired;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: AppTranslations.of(context).loginUsername),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focus);
                      },
                    ),
                    // Password input
                    TextFormField(
                      controller: _passwordController,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppTranslations.of(context)
                              .loginPasswordRequired;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: AppTranslations.of(context).loginPassword),
                      onFieldSubmitted: _checkForm,
                      obscureText: true,
                      focusNode: _focus,
                    ),
                    // Login button
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          onPressed: _checkForm,
                          child: !_isCheckingForm
                              ? Text(AppTranslations.of(context).loginSubmit)
                              : SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
