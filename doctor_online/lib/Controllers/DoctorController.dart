import 'package:doctorapp/Classes/Doctor.dart';
import 'package:doctorapp/Classes/Person.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'LoginController.dart';

class DoctorController {
  FirebaseAuth _firebaseAuth;
  var _firebaseDatabase;
  FirebaseUser user;

  DoctorController() {
    _firebaseDatabase = FirebaseDatabase.instance.reference();
  }

  Future<bool> addDoctorRecord(Person _person, Doctor _Doctor) async {
    try {
      DatabaseReference dbRef = _firebaseDatabase.reference();
      LoginController controller = new LoginController();
      FirebaseUser user = await controller.getCurrentUser();
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
      dbRef.child('Doctor').child(reference.key).set({
        "oAddress": _Doctor.oAddress,
        "YOP": _Doctor.yop,
        "description": _Doctor.description
      });
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
