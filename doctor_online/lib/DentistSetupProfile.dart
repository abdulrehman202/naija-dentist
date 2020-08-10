import 'dart:io';

import 'package:doctorapp/DoctorViewAppointments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'Classes/Doctor.dart';
import 'Classes/Person.dart';
import 'Controllers/DoctorController.dart';
import 'appointment.dart';

class DentistSetupProfile extends StatelessWidget {
  String email;
  DentistSetupProfile(this.email);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    debugShowCheckedModeBanner:
    false;
    return MaterialApp(
      home: _DentistSetupProfile_(email),
    );
  }
}

class _DentistSetupProfile_ extends StatefulWidget {
  String email;
  _DentistSetupProfile_(this.email);
  @override
  State<StatefulWidget> createState() => _DentistSetProfile(email);
}

class _DentistSetProfile extends State<_DentistSetupProfile_> {
  String email;

  var _officeAddressController = new TextEditingController();

  var _yearController = new TextEditingController();
  File _image;
  File _certificate;
  var _descriptionController = new TextEditingController();
  _DentistSetProfile(this.email);
  bool _checkBoxVal = true;
  String _selectedGender;
  String _selectedcity;
  String _selectedstate;
  String _selectedcountry;

  bool _displayMsg = false;

  var _msg = "Select profile Image";
  var _lastNameController = new TextEditingController();

  var _mobileNumberController = new TextEditingController();
  var _firstNameController = new TextEditingController();

  List<String> _gender = ['Male', 'Female'];
  List<String> _country = ['Pakistan', 'India', 'UK', 'USA'];
  List<String> _state = ['North Carolina', 'Nevada', 'Punjab', 'Sindh', 'UP'];
  List<String> _city = ['Lahore', 'New York', 'Pittsburgh', 'Mumbai'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
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
            Container(
              padding: EdgeInsets.all(0.0),
              child: Text(
                'DENTIST',
                style: TextStyle(
                    fontSize: 25,
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
                    fontSize: 20,
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
                padding: EdgeInsets.all(2.0),
                child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: false,
                      hintText: 'First Name',
                    ))),
            Container(
                padding: EdgeInsets.all(2.0),
                child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: false,
                      hintText: 'Last Name',
                    ))),
            Container(
                padding: EdgeInsets.all(2.0),
                child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _mobileNumberController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: false,
                      hintText: 'Phone Number',
                    ))),
            Container(
                padding: EdgeInsets.all(2.0),
                child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _officeAddressController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: false,
                      hintText: 'Office Address',
                    ))),
            Container(
                padding: EdgeInsets.all(2.0),
                child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _yearController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: false,
                      hintText: 'Years of Practice',
                    ))),
            Container(
                padding: EdgeInsets.all(2.0),
                child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: false,
                      hintText: 'Brief Description',
                    ))),
            Container(
              constraints: BoxConstraints(
                minWidth: 300,
                maxWidth: MediaQuery.of(context).size.width - 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _image != null
                        ? Image.asset(
                            _image.path,
                            height: 150,
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
                            ? RaisedButton.icon(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Clear Selection',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: 'Oxygen'),
                                ),
                                color: Colors.red[400],
                                onPressed: clearSelection,
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
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                      width: 200,
                      padding: EdgeInsets.all(5.0),
                      child: RaisedButton(
                        onPressed: () {
                          chooseCertificate();
                        },
                        color: Color(0xff4e45ff),
                        child: Text(
                          'Upload Certificate',
                          style: TextStyle(
                              fontFamily: 'Oxygen',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        padding: const EdgeInsets.all(0),
                      )),
                  Container(
                      width: 200,
                      padding: EdgeInsets.all(5.0),
                      child: RaisedButton(
                        onPressed: () {
                          SaveDoctorData();
                        },
                        color: Color(0xff4e45ff),
                        child: Text(
                          'Save and Continue',
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
            )
          ],
        ),
      ),
    ));
  }

  Future<void> getFilePicker() async {
    File file = await FilePicker.getFile();
    _certificate = file;
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

  Future chooseCertificate() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _certificate = image;
      });
    });
  }

  Future<void> SaveDoctorData() async {
    if (_checkBoxVal == true) {
      if (_image == null) {
        setState(() {
          _msg = "Please upload the profile pic";
          _displayMsg = true;
        });
        return;
      }
      if (_certificate == null) {
        setState(() {
          _msg = "Please upload your certificate";
          _displayMsg = true;
        });
        return;
      }

      if ((_firstNameController.text == '') |
          (_lastNameController.text == '') |
          (_mobileNumberController.text == '') |
          (_officeAddressController.text == '') |
          (_yearController.text == '') |
          (_descriptionController.text == '') |
          (_selectedGender == null) |
          (_selectedstate == null) |
          (_selectedcity == null) |
          (_selectedcountry == null)) {
        setState(() {
          _msg = "You are required to fill all the fields";
          _displayMsg = true;
        });
        return;
      }

      Person _person = new Person(
          _firstNameController.text,
          _lastNameController.text,
          _mobileNumberController.text,
          email,
          'D',
          _selectedGender,
          _selectedcity,
          _selectedcountry,
          _selectedstate);
      Doctor _doctor = new Doctor(_officeAddressController.text,
          _yearController.text, _descriptionController.text);
      DoctorController controller = new DoctorController();
      bool result = await controller.addDoctorRecord(_person, _doctor,_image,_certificate);
      print(result);
      if (result == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorViewAppointments()),
        );
      }
    } else {
      setState(() {
        _msg = "You must agree to our terms of use & privacy policy";
        _displayMsg = true;
      });
    }
  }
}
