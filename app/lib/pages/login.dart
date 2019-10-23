import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ginko/utils/data.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// LoginPage class
/// describes the login widget
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

/// LoginPageState class
/// describes the state of the login widget
class LoginPageState extends State<LoginPage> with AfterLayoutMixin<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _focus = FocusNode();
  String _grade;
  List<String> _grades = grades;
  String _language;
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
      Data.user = User(
        username: _usernameController.text,
        password: _passwordController.text,
        grade: UserValue('grade', _grade),
        language: UserValue('language', _language),
        selection: [],
        tokens: [],
      );
      await Data.load().then((code) async {
        setState(() {
          _isCheckingForm = false;
        });
        switch (code) {
          case ErrorCode.none:
            Navigator.of(context).pop();
            await Navigator.of(context).pushReplacementNamed('/home');
            return;
          case ErrorCode.offline:
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(AppTranslations.of(context).loginFailed),
            ));
            break;
          case ErrorCode.wrongCredentials:
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(AppTranslations.of(context).loginCredentialsWrong),
            ));
            _passwordController.clear();
            FocusScope.of(context).requestFocus(_focus);
            break;
        }
        Data.user = User(
          username: '',
          password: '',
          grade: UserValue('grade', _grade),
          language: UserValue('language', _language),
          selection: [],
          tokens: [],
        );
      });
    } else {
      setState(() {
        _isCheckingForm = false;
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _language = AppTranslations.of(context).locale.languageCode;
    setState(() {
      _grade = AppTranslations.of(context).loginSelectGrade;
      _grades = (_grades.reversed.toList()..add(_grade)).reversed.toList();
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
                    DropdownButtonFormField(
                      items: _grades
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    value,
                                    style: _grades[0] ==
                                            AppTranslations.of(context)
                                                .loginSelectGrade
                                        ? TextStyle(
                                            color: Colors.black54,
                                          )
                                        : null,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: _grade,
                      onChanged: (grade) {
                        setState(() {
                          _grade = grade;
                          _grades.remove(
                              AppTranslations.of(context).loginSelectGrade);
                        });
                      },
                      // ignore: missing_return
                      validator: (value) {
                        if (value ==
                            AppTranslations.of(context).loginSelectGrade) {
                          return AppTranslations.of(context).loginGradeRequired;
                        }
                      },
                    ),
                    // Username input
                    TextFormField(
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
