import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/Classes/Doctor.dart';
import 'package:doctorapp/Classes/Person.dart';
import 'package:doctorapp/Classes/Patient.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'LoginController.dart';

class ChatController {
  final _firestore = Firestore.instance;

  ChatController() {
//    user = LoginController().getCurrentUser();
  }

  Future<void> sendMessage(
      String Message, String receiverUID, String type) async {
    LoginController controller = new LoginController();
    FirebaseUser user = await controller.getCurrentUser();

    print(user.uid);
    _firestore
        .collection('chat')
        .document(user.uid.toString())
        .collection(receiverUID)
        .add({
      'text': Message,
      'senderID': user.email,
      'type': type,
    });

    _firestore
        .collection('chat')
        .document(receiverUID)
        .collection(user.uid)
        .add({
      'text': Message,
      'senderID': user.email,
      'type': type,
    });
  }

  Future<void> sendImage(File file, String receiverUID) async {
    LoginController controller = new LoginController();
    FirebaseUser user = await controller.getCurrentUser();

    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        '${user.uid}/${receiverUID}/${DateTime.now().toIso8601String()}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    sendMessage(
        '${user.uid}/${receiverUID}/${DateTime.now().toIso8601String()}',
        user.uid,
        'image');

//   StorageReference storageReference1 =
//   FirebaseStorage.instance.ref().child('${receiverUID}/${user.uid}');
//   StorageUploadTask uploadTask1 = storageReference1.putFile(file);
//   await uploadTask1.onComplete;
//   sendMessage('${receiverUID}/${user.uid}/${DateTime.now().toIso8601String()}', receiverUID,'image');
  }

  getMessages(String receiverUID) async {
    LoginController controller = new LoginController();
    FirebaseUser user = await controller.getCurrentUser();
    return _firestore
        .collection('chat')
        .document(user.uid)
        .collection(receiverUID)
        .snapshots();
  }
}
