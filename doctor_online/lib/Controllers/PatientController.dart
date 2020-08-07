import 'package:doctorapp/Classes/Patient.dart';
import 'package:doctorapp/Classes/Person.dart';
import 'package:doctorapp/Controllers/LoginController.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PatientController {
  FirebaseAuth _firebaseAuth;
  var _firebaseDatabase;
  FirebaseUser user;

  PatientController() {
    _firebaseDatabase = FirebaseDatabase.instance.reference();
  }

  Future<bool> addPatientRecord(Person _person, Patient _patient) async {
    try {
      DatabaseReference dbRef = _firebaseDatabase.reference();
      LoginController controller = new LoginController();
      FirebaseUser user=await controller.getCurrentUser();
      DatabaseReference reference = dbRef.child('Person').child(user.uid);
      reference.set({
        "firstName": _person.firstName,
        "lastName": _person.lastName,
        "email": _person.email,
        "PType": _person.PType,
        "gender": _person.gender,
        "phoneNo": _person.phoneNo
      });
      reference.child('residence').set({
        "city": _person.city,
        "country": _person.country,
        "state": _person.state
      });
      dbRef.child('Patient').child(reference.key).set({"age": _patient.age});
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
