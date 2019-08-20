import 'package:book_read/enums/connectivity_status.dart';
import 'package:book_read/models/user.dart';
import 'package:book_read/services/database.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:vibration/vibration.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key, this.title = 'Edit Profile'}) : super(key: key);
  final String title;
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _fname = '';
  String _lname = '';
  String _username = '';
  String _bio = '';
  bool isLoading = false;
  Firestore db = Firestore.instance;
  final _dbServ = DatabaseService();
  UserUpdateInfo userUpdateData = new UserUpdateInfo();
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    bool hasVibration = Provider.of<dynamic>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        // brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<User>(
        stream: _dbServ.streamHero(user.uid),
        builder: (context, snapshot) {
          var userData = snapshot.data;
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
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
                            initialValue: userData.username,
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
                            'First Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            initialValue: userData.fname,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              Pattern pattern =
                                  r'^(?=.{1,50}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
                              RegExp regex = new RegExp(pattern);

                              if (value.isEmpty) {
                                return 'Please enter first name';
                              } else if (!regex.hasMatch(value))
                                return 'Invalid format';
                              return null;
                            },
                            onSaved: (value) => _fname = value,
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
                            initialValue: userData.lname,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              Pattern pattern =
                                  r'^(?=.{1,50}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
                              RegExp regex = new RegExp(pattern);

                              if (value.isEmpty) {
                                return 'Please enter last name';
                              } else if (!regex.hasMatch(value))
                                return 'Invalid format';
                              return null;
                            },
                            onSaved: (value) => _lname = value,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Bio',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            initialValue: userData.bio,
                            minLines: 4,
                            maxLines: 8,
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 160,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) => _bio = value,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: isLoading == false
                                ? RoundedButton(
                                    title: 'Submit',
                                    onClick: () async {
                                      if (hasVibration) {
                                        Vibration.vibrate(duration: 200);
                                      }
                                      if (_formkey.currentState.validate()) {
                                        _formkey.currentState.save();
                                        setState(() {
                                          isLoading = true;
                                        });

                                        var data = {
                                          'displayName': _username,
                                          'bio': _bio,
                                          'fname': _fname,
                                          'lname': _lname,
                                        };
                                        userUpdateData.photoUrl = user.photoUrl;
                                        userUpdateData.displayName = _username;
                                        user.updateProfile(userUpdateData);

                                        db
                                            .collection('users')
                                            .document(user.uid)
                                            .updateData(data);

                                        setState(() {
                                          isLoading = false;
                                        });

                                        if (connectionStatus ==
                                            ConnectivityStatus.Offline) {
                                          Navigator.of(context).pop();
                                          Flushbar(
                                            flushbarPosition:
                                                FlushbarPosition.BOTTOM,
                                            margin: EdgeInsets.all(8.0),
                                            borderRadius: 10,
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                            message:
                                                'Device is offline. Data will uploaded once device is back online',
                                            icon: Icon(Icons.error,
                                                color: Colors.white),
                                          )..show(context);
                                        } else {
                                          Navigator.of(context).pop();
                                          Flushbar(
                                            flushbarPosition:
                                                FlushbarPosition.BOTTOM,
                                            margin: EdgeInsets.all(8.0),
                                            borderRadius: 10,
                                            duration: Duration(seconds: 3),
                                            message:
                                                'Successfully updated user account',
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                          )..show(context);
                                        }
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
        },
      ),
    );
  }
}
