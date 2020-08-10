import 'dart:io';

import 'package:doctorapp/Classes/Doctor.dart';
import 'package:doctorapp/Classes/Person.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'LoginController.dart';

class DoctorController {
  var firestoreInstance;
  FirebaseUser user;

  DoctorController() {
    firestoreInstance = Firestore.instance;
  }

  Future<bool> addDoctorRecord(Person _person, Doctor _Doctor,File _image,File _certificate) async {
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
        firestoreInstance.collection('Doctor').document(user.uid).setData({
          "oAddress": _Doctor.oAddress,
          "YOP": _Doctor.yop,
          "description": _Doctor.description,
          "rating":"0"
        }).then((_) {});
        
        
      });
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('${user.uid}/profile');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');

      StorageReference storageReference1 =
          FirebaseStorage.instance.ref().child('${user.uid}/certificate');
      StorageUploadTask uploadTask1 = storageReference1.putFile(_certificate);
      await uploadTask1.onComplete;
      print('File Uploaded');
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
