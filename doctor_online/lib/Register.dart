import 'package:doctorapp/Controllers/LoginController.dart';
import 'package:doctorapp/DentistSetupProfile.dart';
import 'package:doctorapp/SetupProfile.dart';
import 'package:doctorapp/VeriicationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: _SignUp(),
    );
  }
}

class _SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUp();
}

class SignUp extends State<_SignUp> {
  List<String> _type = ['Doctor', 'Patient'];
  String _selectedtype;
  BuildContext _context;
  final _typeController = TextEditingController();
  String _email;
  String _password;
  String _Confirmpassword;
  bool _checkBoxVal = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _displayMsg = false;
  var _msg = "Select profile Image";
  @override
  Widget build(BuildContext context) {
    _context = context;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 120,
                  margin: EdgeInsets.fromLTRB(0, 25, 0, 10),
                  child: ClipRRect(
                    child: Image.asset("images/dr.jpeg"),
//                  padding: new EdgeInsets.all(10.0),
                  ),
                ),
                SizedBox(
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Oxygen'),
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
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                validator: validateEmail,
                                onChanged: (text) {
                                  _email = text;
                                },
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (String input) => _email = input,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: false,
                                  icon: Icon(Icons.email),
                                  hintText: 'Email',
                                ))),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                onChanged: (text) {
                                  _password = text;
                                },
                                keyboardType: TextInputType.text,
                                validator: validatePassword,
                                onSaved: (String input) => _password = input,
                                obscureText: true,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: false,
                                  icon: Icon(Icons.lock),
                                  hintText: 'Password',
                                ))),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                validator: validateConfirmPassword,
                                onSaved: (String input) =>
                                    _Confirmpassword = input,
                                obscureText: true,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: false,
                                  icon: Icon(Icons.lock),
                                  hintText: 'Confirm Password',
                                ))),
                        Container(
                            child: DropdownButton(
                          hint: Text('Account Type'),
                          value: _selectedtype,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedtype = newValue;
                            });
                          },
                          items: _type.map((type) {
                            return DropdownMenuItem(
                              child: new Text(type),
                              value: type,
                            );
                          }).toList(),
                        )),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: _checkBoxVal,
                        activeColor: Colors.orange,
                        onChanged: (newValue) {
                          setState(() {
                            _checkBoxVal = newValue;
                          });
                        },
                      ),
                      Container(
                        child: Text(
                          'By creating your account, your are agree\nto our terms of use & privacy policy ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: const Color(0xff6b6b6b),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    width: 250,
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      onPressed: () {
                        _functionSignUp();
                      },
                      color: Color(0xff4e45ff),
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                            fontFamily: 'Oxygen',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      padding: const EdgeInsets.all(0),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _functionSignUp() {
    try {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => DentistSetupProfile('_email')),
      // );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SetupProfile('_email')),
      // );
      if ((_email == null) | (_password == null)) {
        setState(() {
          _displayMsg = true;
          _msg = "Incomplete Fields";
          return;
        });
      }
      _email = _email.replaceAll(new RegExp(r"\s+"), "");
      _password = _password.trim();
      _validateInputs();
      if (_autoValidate == false) {
        if (_checkBoxVal) {
          print('Yes');
          if (_selectedtype != 'Account Type') {
            LoginController loginController = new LoginController();
            print('come');
            _email = _email.toLowerCase();
            Future<String> user =
                loginController.CreateNewUser(_email, _password);
            if (user.toString().compareTo(' ') != 0) {
              print('successful');
              if (_selectedtype == 'Patient') {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) =>VerificationScreen_('P',_email)),
                // );
                Navigator.push(context,
              MaterialPageRoute(builder: (context) => SetupProfile(_email)));
              } else if (_selectedtype == 'Doctor') {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => VerificationScreen_('D',_email)),
                // );
                Navigator.push(context,
              MaterialPageRoute(builder: (context) => DentistSetupProfile(_email)));
              }
            } else {
              print('unsuccessful');
            }
          }
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

  String validateConfirmPassword(String value) {
    if (value != _password) {
      return 'Both Password doesn' 't matches';
    }
    return null;
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
