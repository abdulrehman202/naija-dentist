import 'package:doctorapp/Classes/DoctorAppointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'LoginController.dart';

class ChatListController {
  var _firebaseDatabase;
  FirebaseUser user;
  var firestoreInstance;
  ChatListController() {
    _firebaseDatabase = FirebaseDatabase.instance.reference();
    firestoreInstance = Firestore.instance;
  }

  Future<List<DoctorAppointments>> getPatientAppointments() async {
    try {
      LoginController loginController = new LoginController();
      user = await loginController.getCurrentUser();
      List<DoctorAppointments> list = new List();

      QuerySnapshot value1 = await Firestore.instance
          .collection('PatientAppointment')
          .document(user.uid) //DoctorID
          .collection("Doctors")
          .getDocuments();

      // print('list length is: ${value1.documents.length}');
      for (DocumentSnapshot element in value1.documents) {
        // print(element.documentID);
        DoctorAppointments appointments = new DoctorAppointments();

        DocumentSnapshot value01 = await Firestore.instance
            .collection("Person")
            .document(element.documentID)
            .get();
        if (value01.data != null) {
          appointments.name =
              value01.data["firstName"] + ' ' + value01.data["lastName"];
        }
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('${element.documentID}/profile');

        await storageReference.getDownloadURL().then((fileURL) {
          appointments.uploadedFileURL = fileURL;
        });
        appointments.patientId=element.documentID;
        list.add(appointments);
      }
      print("list len :${list.length}");
      return list;
    } catch (e) {
      print(e);
    }
  }
}
