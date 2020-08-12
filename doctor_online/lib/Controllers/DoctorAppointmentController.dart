import 'package:doctorapp/Classes/DoctorAppointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'LoginController.dart';

class DoctorAppointmentController {
  var _firebaseDatabase;
  FirebaseUser user;
  var firestoreInstance;
  DoctorAppointmentController() {
    _firebaseDatabase = FirebaseDatabase.instance.reference();
    firestoreInstance = Firestore.instance;
  }

  Future<List<DoctorAppointments>> getDoctorAppointments(var Date) async {
    try {
      print(Date);
      LoginController loginController = new LoginController();
      user = await loginController.getCurrentUser();

      List<DoctorAppointments> list = new List();
      String u = user.uid.toString();
      QuerySnapshot value = await Firestore.instance
          .collection('Appointment')
          .document(u) //DoctorID
          .collection("Date")
          .getDocuments();

      for (DocumentSnapshot element in value.documents) {
        if (element.data["date"] == Date) {
          DoctorAppointments appointments = new DoctorAppointments();
          appointments.communication = element.data["communication"];
          appointments.date = Date;
          appointments.time = element.data["time"];
          DocumentSnapshot value01 = await Firestore.instance
              .collection("Person")
              .document(element["patientID"])
              .get();
          if (value01.data != null) {
            appointments.name =
                value01.data["firstName"] + ' ' + value01.data["lastName"];
          }
          DocumentSnapshot value03 = await Firestore.instance
              .collection("Patient")
              .document(element["patientID"])
              .get();
          if (value03.data != null) {
            appointments.age = value03.data["age"];
          }

          appointments.patientId = element["patientID"];

          StorageReference storageReference = FirebaseStorage.instance
              .ref()
              .child('${element["patientID"]}/profile');
             
            await storageReference.getDownloadURL().then((fileURL) {
              appointments.uploadedFileURL = fileURL;
            });
          
          list.add(appointments);
        }
      }
      print("list len :${list.length}");
      return list;
    } catch (e) {
      print(e);
    }
  }

  Future<List<DoctorAppointments>> getDoctorAppointmentsWithout() async {
    try {
      LoginController loginController = new LoginController();
      user = await loginController.getCurrentUser();
      List<DoctorAppointments> list = new List();
      String u = user.uid.toString();
      QuerySnapshot value = await Firestore.instance
          .collection('Appointment')
          .document(u) //DoctorID
          .collection("Date")
          .getDocuments();

      for (DocumentSnapshot element in value.documents) {
        DoctorAppointments appointments = new DoctorAppointments();
        appointments.communication = element.data["communication"];
        appointments.date = element.data["date"];
        appointments.time = element.data["time"];
        DocumentSnapshot value01 = await Firestore.instance
            .collection("Person")
            .document(element["patientID"])
            .get();
        if (value01.data != null) {
          appointments.name =
              value01.data["firstName"] + ' ' + value01.data["lastName"];
        }
        DocumentSnapshot value03 = await Firestore.instance
            .collection("Patient")
            .document(element["patientID"])
            .get();
        if (value03.data != null) {
          appointments.age = value03.data["age"];
        }
        appointments.patientId = element["patientID"];

        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('${element["patientID"]}/profile');
        await storageReference.getDownloadURL().then((fileURL) {
          appointments.uploadedFileURL = fileURL;
        });
        list.add(appointments);
      }
      print("list len :${list.length}");
      return list;
    } catch (e) {
      print(e);
    }
  }
}
