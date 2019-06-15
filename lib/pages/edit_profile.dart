import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                    'First Name',
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
                    'Last Name',
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
                    obscureText: !_showPassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      _password = value;

                      if (value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length < 6) {
                        return 'Password is too short';
                      }
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

                                var data = {
                                  'displayName': _username,
                                  'email': _email,
                                  'bio': '',
                                  'fname': '',
                                  'lname': '',
                                  'profile_pic':
                                      'https://firebasestorage.googleapis.com/v0/b/ifunny-66ef2.appspot.com/o/bg_placeholder.jpeg?alt=media&token=1f6da019-f9ed-4635-a040-33b8a0f80d25',
                                  'uid': user.uid
                                };
                                db
                                    .collection('users')
                                    .document(user.uid)
                                    .setData(data);
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pushNamed('/');
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
    );
  }
}
