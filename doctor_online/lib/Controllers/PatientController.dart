import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/Classes/Patient.dart';
import 'package:doctorapp/Classes/Person.dart';
import 'package:doctorapp/Controllers/LoginController.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PatientController {
  FirebaseUser user;
  var firestoreInstance;
  PatientController() {
    firestoreInstance = Firestore.instance;
  }

  Future<bool> addPatientRecord(
      Person _person, Patient _patient, File _image) async {
    try {
      LoginController controller = new LoginController();
      FirebaseUser user = await controller.getCurrentUser();
      firestoreInstance.collection('Person').document(user.uid).setData({
        "firstName": _person.firstName,
        "lastName": _person.lastName,
        "email": _person.email,
        "PType": _person.PType,
        "gender": _person.gender,
        "phoneNo": _person.phoneNo,
        "residance": {
          "city": _person.city,
          "country": _person.country,
          "state": _person.state
        }
      }).then((_) {
        firestoreInstance
            .collection('Patient')
            .document(user.uid)
            .setData({"age": _patient.age}).then((_) {});
      });

      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('${user.uid}/profile');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');

      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
