import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/Controllers/LoginController.dart';
import 'package:doctorapp/Register.dart';
import 'package:doctorapp/SetupProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DentistSetupProfile.dart';
import 'DoctorViewAppointments.dart';
import 'appointment.dart';

class VerificationScreen_ extends StatelessWidget {
  var Type;
  var email;
  VerificationScreen_(this.Type, this.email);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        //'/signup': (BuildContext context) => new SignupPage(),
        //'/otostop': (BuildContext context) => new OtoStop7Temp()
        // '/otostop': (BuildContext context) => new Message()
      },
      home: new VerificationScreen(Type, email),
    );
  }
}

class VerificationScreen extends StatefulWidget {
  var Type, email;
  VerificationScreen(this.Type, this.email);
  @override
  _VerificationScreen createState() => new _VerificationScreen(Type, email);
}

class _VerificationScreen extends State<VerificationScreen> {
  var Type, email;
  _VerificationScreen(this.Type, this.email);
  bool _displayMsg = false;
  var _msg = "Select profile Image";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  'VerificationScreen', //VerificationScreen logo
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
                height: 20,
              ),
              Container(
                child: Text(
                  '1. We have email you a verification link\n2. Click on that link to verify your email address\n3. After verifying click on the verified button to go to next screen', //VerificationScreen logo
                  style: TextStyle(
                    fontFamily: 'Oxygen',
                    fontSize: 17,
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
              Container(
                margin: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  onPressed: () {
                    _VerifyEmail();
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
                      'Verified',
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
      ),
    );
  }

  Future<void> _VerifyEmail() async {
    try {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PatientViewDoctors())
      // );

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
      LoginController controller = LoginController();

      bool result = await controller.isEmailVerified();
      FirebaseUser user = await controller.getCurrentUser();
      print('${user.uid} ' + ' $result');
      if (user.isEmailVerified) {
        if (Type == 'P') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SetupProfile(email)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DentistSetupProfile(email)));
        }
      } else {
        setState(() {
          _displayMsg = true;
          _msg = "You haven't verified your email yet!";
          return;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
