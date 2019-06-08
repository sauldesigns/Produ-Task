import 'package:book_read/ui/rounded_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Login', style: TextStyle(color: Colors.black)),
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
                      'E-mail',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        }
                      },
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
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: RoundedButton(
                        title: 'Login',
                        onClick: () {
                          if (_formkey.currentState.validate()) {
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
