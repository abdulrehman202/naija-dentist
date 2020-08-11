import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/Chat_List.dart';
import 'package:doctorapp/Register.dart';
import 'package:doctorapp/SetupProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Controllers/LoginController.dart';
import 'DentistSetupProfile.dart';
import 'DoctorViewAppointments.dart';
import 'appointment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        //'/signup': (BuildContext context) => new SignupPage(),
        //'/otostop': (BuildContext context) => new OtoStop7Temp()
        // '/otostop': (BuildContext context) => new Message()
      },
      home: new Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _Login createState() => new _Login();
}

class _Login extends State<Login> {
  var _email, _password;
  bool _autoValidate = false;
  bool _displayMsg = false;
  var _msg = "Select profile Image";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                width: 250.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('images/dr.jpeg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  'Login', //Login logo
                  style: TextStyle(
                    fontFamily: 'Oxygen',
                    fontSize: 30,
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _displayMsg
                  ? Text(
                      '$_msg',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[500],
                          fontFamily: 'Oxygen'),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      validator: validateEmail,
                      onChanged: (text) {
                        _email = text;
                      },
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: false,
                        icon: Icon(Icons.email),
                        hintText: 'Username/Email',
                      ),
                      onSaved: (input) => _email = input,
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: validatePassword,
                        onChanged: (text) {
                          _password = text;
                        },
                        obscureText: true,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: false,
                          icon: Icon(Icons.lock),
                          hintText: 'Password',
                        ),
                        onSaved: (input) => _password = input,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: RaisedButton(
                        onPressed: () {
                          _functionSignUp();
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          width: 220,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                const Color(0xff3126c9),
                                const Color(0xff857dfa)
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Oxygen',
                              fontSize: 14,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Do not have an account?',
                      style: TextStyle(
                        fontFamily: 'Oxygen',
                        fontSize: 16,
                        color: const Color(0xff6e6e6e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Oxygen',
                          fontSize: 16,
                          color: const Color(0xff4585fe),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpClass()));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _functionSignUp() async {
    try {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => ChatList()));

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SetupProfile('email'))
      // );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => DentistSetupProfile('email'))
      // );
      //  Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => DoctorViewAppointments())
      // );
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => PatientViewDoctors()));

      if ((_email == null) | (_password == null)) {
        setState(() {
          _displayMsg=true;
          _msg="Incomplete Fields";
          return;
        });
      }
      _email = _email.replaceAll(new RegExp(r"\s+"), "");
      _password = _password.trim();
      _validateInputs();
      if (_autoValidate == false) {
        LoginController loginController = new LoginController();
        String user = await loginController.CheckSignIn(_email, _password);
        if (user.toString().compareTo(' ') != 0) {
          print('successful');

          DocumentSnapshot value01 = await Firestore.instance
              .collection("Person")
              .document(user)
              .get();
          if (value01.data != null) {
            var type = value01.data["PType"];
            if (type == 'P') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientViewDoctors()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DoctorViewAppointments()),
              );
            }
          }
        } else {
          setState(() {
          _displayMsg=true;
          _msg="Incorrect Username or Password";
          return;
        });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      //    If all data are correct then save data to out variables
      _formKey.currentState.save();
      _autoValidate = false;
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Password must contain Minimum 1 Upper case,\nMinimum 1 lowercase,\n Minimum 1 Numeric Number,\n Minimum 1 Special Character';
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim()))
      return 'Enter Valid Email';
    else
      return null;
  }
}
