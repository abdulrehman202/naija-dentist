import 'package:doctorapp/Controllers/LoginController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Classes/SetAppointment.dart';

class SetAppointmentController {
  var firestoreInstance;

  SetAppointmentController() {
    firestoreInstance = Firestore.instance;
  }

  Future<bool> AddPatientsRecords(SetAppointmentClass set, var doctorID) async {
    try {
      print('Success');
      LoginController log_controller = new LoginController();
      FirebaseUser user = await log_controller.getCurrentUser();
      Firestore.instance
          .collection('Appointment')
          .document(doctorID)
          .collection('Date')
          .add({
        'time': set.time,
        'date': set.date,
        'patientID': user.uid,
        'communication': set.method,
        'rate': set.cost
      });
      Firestore.instance
          .collection('PatientAppointment').document(user.uid).collection("Doctors").document(doctorID).setData({
            "doctorID":doctorID
          });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

//  Future<Null> setAppointment(SetAppointmentClass set) async {
//    try {
//      DatabaseReference dbRef = _firebaseDatabase.reference();
//      dbRef.child('Appointment').push().set({
//        "Did": 2,
//        "Pid": 3,
//        "cost": '300',
//        "date": set.date,
//        "communication": 'video',
//        "time": set.time
//      });
//    } catch (e) {
//      print('exx');
//      print(e);
//    }
//  }
}
