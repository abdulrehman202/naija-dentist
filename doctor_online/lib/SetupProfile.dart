import 'dart:io';
import 'package:doctorapp/Classes/Patient.dart';
import 'package:doctorapp/Classes/Person.dart';
import 'package:doctorapp/Controllers/PatientController.dart';
import 'package:doctorapp/appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SetupProfile extends StatelessWidget {
  String email;
  SetupProfile(this.email);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    debugShowCheckedModeBanner:
    false;
    return MaterialApp(
      home: new _SetupProfile_(email),
    );
  }
}

class _SetupProfile_ extends StatefulWidget {
  String email;
  _SetupProfile_(this.email);
  @override
  State<StatefulWidget> createState() => _SetupProfile(email);
}

class _SetupProfile extends State<_SetupProfile_> {
  bool _checkBoxVal = false;
  String email;

  File _image;
  var _lastNameController = new TextEditingController();

  var _mobileNumberController = new TextEditingController();

  bool _displayMsg = false;

  var _msg = "Select profile Image";

  bool _progressVisible = false;
  _SetupProfile(this.email);

  String _selectedGender;
  String _selectedtype;
  String _selectedcity;
  String _selectedstate;
  String _selectedcountry;
  List<String> _gender = ['Male', 'Female'];
  List<String> _country = ['Pakistan', 'India', 'UK', 'USA'];
  List<String> _state = ['North Carolina', 'Nevada', 'Punjab', 'Sindh', 'UP'];
  List<String> _city = ['Lahore', 'New York', 'Pittsburgh', 'Mumbai'];
  List<String> _type = [
    '0-5',
    '6-10',
    '11-15',
    '16-19',
    '20-45',
    'Above 45'
  ]; // List for the options for Gender
  var _firstNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            //physics: NeverScrollableScrollPhysics(),
            child: Column(
              /*crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.start,*/
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
                Container(
                  child: Text(
                    'Patient',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Oxygen'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    'SetUp Profile',
                    style: TextStyle(
                        fontSize: 25,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*All the fields are required',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[500],
                        fontFamily: 'Oxygen'),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        controller: _firstNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: false,
                          hintText: 'First Name',
                        ))),
                Container(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        controller: _lastNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: false,
                          hintText: 'Last Name',
                        ))),
                Container(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        controller: _mobileNumberController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: false,
                          hintText: 'Mobile Number',
                        ))),
                Container(
                  child: DropdownButton(
                    hint: Text('Select Country'),
                    value: _selectedcountry,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedcountry = newValue;
                      });
                    },
                    items: _country.map((country) {
                      return DropdownMenuItem(
                        child: new Text(country),
                        value: country,
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    minWidth: 300,
                    maxWidth: MediaQuery.of(context).size.width - 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: DropdownButton(
                          hint: Text('Select City'),
                          value: _selectedcity,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedcity = newValue;
                            });
                          },
                          items: _city.map((city) {
                            return DropdownMenuItem(
                              child: new Text(city),
                              value: city,
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: DropdownButton(
                          hint: Text('Select State'),
                          value: _selectedstate,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedstate = newValue;
                            });
                          },
                          items: _state.map((state) {
                            return DropdownMenuItem(
                              child: new Text(state),
                              value: state,
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    child: DropdownButton(
                  hint: Text('Select Gender'),
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: _gender.map((gender) {
                    return DropdownMenuItem(
                      child: new Text(gender),
                      value: gender,
                    );
                  }).toList(),
                )),
                Container(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: DropdownButton(
                        hint: Text('Select Age'),
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
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image != null
                            ? Image.asset(
                                _image.path,
                                width: 100,
                                height: 100,
                              )
                            : Container(height: 80),
                        Column(
                          children: <Widget>[
                            _image == null
                                ? RaisedButton(
                                    child: Text(
                                      'Choose Profile Pic',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontFamily: 'Oxygen'),
                                    ),
                                    onPressed: chooseFile,
                                    color: Colors.cyan,
                                  )
                                : Container(),
                            _image != null
                                ? Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 20,
                                      ),
                                      RaisedButton.icon(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Remove',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              fontFamily: 'Oxygen'),
                                        ),
                                        color: Colors.red[400],
                                        onPressed: clearSelection,
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: _checkBoxVal,
                        activeColor: Colors.orange,
                        onChanged: (newValue) {
                          setState(() {
                            print(newValue);
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: _progressVisible,
                  child: CircularProgressIndicator(),
                ),
                Container(
                    width: 250,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _progressVisible = true;
                        });
                        SavePatientData();
                      },
                      color: Color(0xff4e45ff),
                      child: Text(
                        'Save And Continue',
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

  void clearSelection() {
    setState(() {
      _image = null;
    });
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future<bool> _onBackPressed() {
    print('test');
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: roundedButton(
                    "No", const Color(0xFF167F67), const Color(0xFFFFFFFF)),
              ),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: roundedButton(
                    " Yes ", const Color(0xFF167F67), const Color(0xFFFFFFFF)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }

  Future<void> SavePatientData() async {
    if (_checkBoxVal == true) {
      if (_image == null) {
        setState(() {
          _msg = "Please upload the profile pic";
          _displayMsg = true;
          _progressVisible = false;
        });
        return;
      }

      if ((_firstNameController.text == '') |
          (_lastNameController.text == '') |
          (_mobileNumberController.text == '') |
          (_selectedGender == null) |
          (_selectedstate == null) |
          (_selectedtype == null) |
          (_selectedcity == null) |
          (_selectedcountry == null)) {
        setState(() {
          _msg = "You are required to fill all the fields";
          _displayMsg = true;
          _progressVisible = false;
        });
        return;
      }

      Person _person = new Person(
          _firstNameController.text,
          _lastNameController.text,
          _mobileNumberController.text,
          email,
          'P',
          _selectedGender,
          _selectedcity,
          _selectedcountry,
          _selectedstate);
      Patient _patient = new Patient(_selectedtype);
      PatientController controller = new PatientController();
      bool result =
          await controller.addPatientRecord(_person, _patient, _image);
      print(result);
      setState(() {
        _progressVisible = false;
        _displayMsg = false;
      });
      if (result == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientViewDoctors()),
        );
      }
    } else {
      setState(() {
        _msg = "You must agree to our terms of use & privacy policy";
        _displayMsg = true;
        _progressVisible = false;
      });
    }
  }
}
