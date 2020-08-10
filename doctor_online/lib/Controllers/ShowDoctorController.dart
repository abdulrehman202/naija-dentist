import 'package:doctorapp/Classes/DoctorAppointments.dart';
import 'package:doctorapp/appointment.dart';
import 'package:doctorapp/appointment_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'LoginController.dart';

class ShowDoctorController {
  var _firebaseDatabase;
  FirebaseUser user;
  var firestoreInstance;
  ShowDoctorController() {
    _firebaseDatabase = FirebaseDatabase.instance.reference();
    firestoreInstance = Firestore.instance;
  }

  Future<List<appointment_class>> getDoctorAppointments() async {
    try {
      LoginController loginController = new LoginController();
      user = await loginController.getCurrentUser();

      List<appointment_class> list = new List();
      String u = user.uid.toString();
      QuerySnapshot value = await Firestore.instance
          .collection('Person')
          .where('PType', isEqualTo: 'D')
          .getDocuments();
      for (DocumentSnapshot element in value.documents) {
        appointment_class app = new appointment_class();
        app.doctor_name =
            element.data["firstName"] + ' ' + element.data["lastName"];
        DocumentSnapshot value01 = await Firestore.instance
            .collection("Doctor")
            .document(element.documentID)
            .get();
        if (value01.data != null) {
          app.doctorID = element.documentID;
          app.YOP = value01.data["YOP"];
          app.Description = value01.data["description"];
          app.OAddress = value01.data["oAddress"];
          app.rating = value01.data["rating"];
        }
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('${element.documentID}/profile');

        await storageReference.getDownloadURL().then((fileURL) {
          app.uploadedFileURL = fileURL;
        });

        list.add(app);
      }
      print("list len :${list.length}");
      return list;
    } catch (e) {
      print(e);
    }
  }
}
