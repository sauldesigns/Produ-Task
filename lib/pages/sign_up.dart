import 'package:book_read/services/auth.dart';
import 'package:book_read/services/user_repo.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

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
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool isLoading = false;
  Firestore db = Firestore.instance;
  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    var userRepo = Provider.of<UserRepository>(context);
    if (user != null) {
      Navigator.of(context).pop();
    }
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Sign Up', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
      ),
      // backgroundColor: Color.fromRGBO(255, 218, 185, 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        Pattern pattern =
                            r'^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'Please enter username';
                        } else if (!regex.hasMatch(value))
                          return 'Not a valid username';
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
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        } else if (EmailValidator.validate(value) == false) {
                          return 'Not a valid email';
                        }
                        return null;
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
                      obscureText: !_showPassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        _password = value;

                        if (value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6) {
                          return 'Password is too short';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      obscureText: !_showConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6) {
                          return 'Password is too short';
                        } else if (value != _password) {
                          return 'Passwords did not match';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: isLoading == false
                          ? RoundedButton(
                              title: 'Sign up',
                              onClick: () async {
                                if (_formkey.currentState.validate()) {
                                  _formkey.currentState.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var userId =
                                      await userRepo.signUp(_email, _password);
                                  if (userId != 'error') {
                                    var data = {
                                      'displayName': _username,
                                      'email': _email,
                                      'bio': '',
                                      'fname': '',
                                      'lname': '',
                                      'provider': 'email',
                                      'profile_pic':
                                          'https://firebasestorage.googleapis.com/v0/b/ifunny-66ef2.appspot.com/o/bg_placeholder.jpeg?alt=media&token=1f6da019-f9ed-4635-a040-33b8a0f80d25',
                                      'uid': userId
                                    };
                                    db
                                        .collection('users')
                                        .document(userId)
                                        .setData(data);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
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

  @override
  void dispose() {
    _email = '';
    _password = '';
    super.dispose();
  }
}
