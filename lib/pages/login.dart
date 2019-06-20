import 'package:book_read/services/auth.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  String _password;
  bool isLoading = false;

  void _validateAndSubmit() async {
    setState(() {
      isLoading = true;
    });
    await widget.auth.signIn(_email, _password);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Login', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
      ),
      // backgroundColor: Color.fromRGBO(255, 218, 185, 1),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: this._formkey,
            autovalidate: _autoValidate,
            child: Center(
              child: Container(
                padding: EdgeInsets.only(top: 70),
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'E-mail',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        } else if (EmailValidator.validate(value) == false) {
                          return 'Not a valid email';
                        }
                      },
                      onSaved: (value) => _email = value,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6) {
                          return 'Password is too short';
                        }
                      },
                      onSaved: (value) => _password = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: isLoading == false
                          ? RoundedButton(
                              title: 'Login',
                              onClick: () {
                                if (_formkey.currentState.validate()) {
                                  _formkey.currentState.save();
                                  // auth.signInAnonymously();
                                  _validateAndSubmit();
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
