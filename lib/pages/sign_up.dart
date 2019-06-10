import 'package:book_read/services/auth.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  String _password;
  String _username;
  Firestore db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Sign Up', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Color.fromRGBO(255, 218, 185, 1),
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
                      'Username',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'E-mail',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
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
                      child: RoundedButton(
                        title: 'Sign up',
                        onClick: () async {
                          if (_formkey.currentState.validate()) {
                            _formkey.currentState.save();
                            var userId =
                                await widget.auth.signUp(_email, _password);
                            var data = {
                              'displayName': _username,
                              'email': _email,
                              'bio': '',
                              'fname': '',
                              'lname': '',
                              'profile_pic': '',
                              'uid': userId
                            };
                            db.collection('users').add(data);
                            Navigator.of(context).pushNamed('/');
                          } else {
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        },
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
