import 'package:book_read/services/auth.dart';
import 'package:book_read/services/user_repo.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth, this.scaffoldKey}) : super(key: key);
  final BaseAuth auth;
  final GlobalKey<ScaffoldState> scaffoldKey;
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  bool showError = false;
  String _password;
  bool isLoading = false;
  final FocusNode _emailFocus = new FocusNode();
  final FocusNode _passwordFocus = new FocusNode();

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  doSignIn(var userRepo, BuildContext context) async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      bool result = await userRepo.signIn(_email, _password);
      if (result == true) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else {
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          margin: EdgeInsets.all(8.0),
          borderRadius: 10,
          duration: Duration(seconds: 5),
          message: 'Error! Either password or e-mail are incorrect.',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
        )..show(context);
        setState(() {
          showError = true;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Login', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
      ),
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
                      'E-mail',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        } else if (EmailValidator.validate(value) == false) {
                          return 'Not a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value,
                      onFieldSubmitted: (term) => _fieldFocusChange(
                          context, _emailFocus, _passwordFocus),
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
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocus,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6) {
                          return 'Password is too short';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value,
                      onFieldSubmitted: (term) {
                        setState(() {
                          isLoading = true;
                        });
                        _passwordFocus.unfocus();
                        doSignIn(userRepo, context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: isLoading == false
                          ? RoundedButton(
                              title: 'Login',
                              onClick: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                doSignIn(userRepo, context);
                              },
                            )
                          : SpinKitChasingDots(
                              color: Colors.black,
                              size: 30,
                            ),
                    ),
                    showError == false
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'Error signing in. Please try again.',
                              style: TextStyle(
                                color: Colors.red,
                              ),
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
