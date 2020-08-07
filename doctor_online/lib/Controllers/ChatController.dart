import 'package:doctorapp/Classes/Doctor.dart';
import 'package:doctorapp/Classes/Person.dart';
import 'package:doctorapp/Classes/Patient.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'LoginController.dart';


class ChatController{

  var _firebaseDatabase;
  FirebaseUser user;

  ChatController() {
    _firebaseDatabase = FirebaseDatabase.instance.reference();
  }

  Future<Null> sendMessage(int Sid,int Rid,String Message)
  async {

    DatabaseReference dbRef = _firebaseDatabase.reference();
    LoginController controller = new LoginController();
    FirebaseUser user = await controller.getCurrentUser();
    dbRef.child('Chat').push().set({
      "id": 2,
      "receiverId": Rid,
      "senderId": Sid,
      "message": Message,
      "time": DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),
    });


  }


}

