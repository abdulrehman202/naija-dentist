import 'dart:io';

import 'package:camera/camera.dart';
import 'package:doctorapp/Controllers/LoginController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/main.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:doctorapp/WColors.dart';
import 'package:doctorapp/Controllers/ChatController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:doctorapp/src/pages/video_call.dart';
import 'package:doctorapp/src/pages/audio_call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Classes/DoctorAppointments.dart';
import 'Controllers/ChatController.dart';
import 'Controllers/ChatController.dart';
import 'Controllers/ChatController.dart';
import 'Controllers/ChatController.dart';

var firstCamera;
final _firestore = Firestore.instance;
Future<FirebaseUser> user = (FirebaseAuth.instance.currentUser());
DoctorAppointments apt;
var channel_id;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  firstCamera = cameras.first;

}

cam()
async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  firstCamera = cameras.first;
}

Future<void> getUID()
async {
  LoginController controller = new LoginController();
  FirebaseUser user=await controller.getCurrentUser();
  uid = user.uid;
}

Future<void> getUEmail()
async {
  LoginController controller = new LoginController();
  FirebaseUser user=await controller.getCurrentUser();
  uemail = user.email;
}

String receiver,uid,uemail,receiver_name,receiver_pic;

class ChatScreen extends StatelessWidget {

  ChatScreen(String rid,String name,String picURL)
  {
    receiver = rid;
    getUID();
    getUEmail();
    receiver_name = name;
    receiver_pic = picURL;
    channel_id = '${uid} ${receiver}';
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(



      theme: ThemeData(
        fontFamily: 'Oxygen',
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        //'/signup': (BuildContext context) => new SignupPage(),
      },
      home: new ChatScreenPage(),

    );
  }
}

class ChatScreenPage extends StatefulWidget {

  @override
  _ChatScreenPageState createState() => new _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {

  ClientRole _role = ClientRole.Broadcaster;
  MediaQueryData queryData;
  WColors myColors;
  var msgController = new TextEditingController();
  Category category;
  OnEmojiSelected onEmojiSelected;

  var _showBottomAppBar = false;

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onShow: (bool visible) {
        _showBottomAppBar = true;
        print(visible);
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    queryData = MediaQuery.of(context);
    myColors = new WColors();
    var widthD = queryData.size.width;
    var heightD = queryData.size.height;

    return new  Scaffold(

            bottomNavigationBar: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: BottomAppBar(
                color: Color(0xfffffffc),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(7, 0, 0, 2),
                        padding: EdgeInsets.all(0),
                        width: 30.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            size: 22,
                          ),
                          color: myColors.bottomBarIcons,
                          onPressed: () async {
                            print('attach');
                            List<File> files = await FilePicker.getMultiFile(
                              type: FileType.custom,
                              allowedExtensions: [ 'pdf', 'doc'],
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0),
                        width: 30.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.image,
                            size: 22,
                          ),
                          color: myColors.bottomBarIcons,
                          onPressed: () async {
//                            print('Image');
//                            List<File> files = await FilePicker.getMultiFile(
//                              type: FileType.custom,
//                              allowedExtensions: [ 'jpg'],
//                            );
//                            File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
//                            ChatController().sendImage(_image, receiver);
//                            ChatController().sendMessage('<ImageFile>', receiver);
                            final picker = ImagePicker();
                            final pickedFile = await picker.getImage(source: ImageSource.gallery);

                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(imagePath: pickedFile.path),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0),
                        width: 30.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 22,
                          ),
                          color: myColors.bottomBarIcons,
                          onPressed: () async {
                            cam();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TakePictureScreen(
                                    camera: firstCamera,)
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0),
                        width: 30.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.mic,
                            size: 24,
                          ),
                          color: myColors.bottomBarIcons,
                          onPressed: () {
                            print('mic');
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(38.0),
                            color: const Color(0xfff7f7f7),
                            border: Border.all(
                                width: 0.3, color: const Color(0xff707070)),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 175,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: msgController,
//                                    onTap: (){
//                                      _showBottomAppBar = true;
//                                    },
                                    style: TextStyle(
                                      fontFamily: 'Oxygen',
                                      fontSize: 15,
                                      color: Colors.black,

                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hoverColor: Colors.yellow,
                                      hintText: 'Write your message here',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: const Color(0xffa0a0a0),

                                      ),
                                    ),
                                    maxLines: null,
                                    keyboardType: TextInputType.text,

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                        padding: EdgeInsets.all(0),
                        width: 20.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 24,
                          ),
                          color: myColors.appBar,
                          onPressed:()
                          {
                            sendMessage(msgController.text.toString());
                            msgController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: myColors.appBar,
              title: Row(
                children: <Widget>[
                  /*GestureDetector(
                child: Container(
                  child: Icon(Icons.arrow_back, color: myColors.appBarIcons),
                  alignment: Alignment.topLeft,
                  width: 40,
                ),
                onTap: () {
                  _navigateToBackScreen(context);
                },
              ),*/
                  GestureDetector(
                    child: ClipOval(
                      //borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        receiver_pic,
                        width: 40,
                        height: 40,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(13, 0, 0, 0),
                    child: Text(
                      receiver_name,
                      style: TextStyle(
                        fontFamily: 'Oxygen',
                        fontSize: 19,
                        color: myColors.appBarIcons,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.phone,
                    size: 24,
                  ),
                  color: myColors.appBarIcons,
                  onPressed: ()
                  {
                    MaterialPageRoute(
                        builder: (context) => VoiceCallPage(),
                    );

                    ChatController().sendMessage(channel_id, receiver, 'voicecall');

                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.videocam,
                    size: 24,
                  ),
                  color: myColors.appBarIcons,
                  onPressed: onJoin,
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 24,
                  ),
                  color: myColors.appBarIcons,
                  onPressed: () {},
                ),
              ],
            ),
            resizeToAvoidBottomPadding: false,
            backgroundColor: const Color(0xffffffff),
            body: SafeArea(
              child:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          margin: EdgeInsets.fromLTRB(25, 45, 25, 45),
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                //borderRadius: BorderRadius.circular(100.0),
                                child: Image.asset(
                                  'images/man_pic.jpg',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Dr. James Howard',
                                      maxLines: null,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontFamily: 'Oxygen',
                                        fontSize: 16,
                                        color: const Color(0xff707070),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      Text(
                                        'United Kingdom',
                                        style: TextStyle(
                                          fontFamily: 'Oxygen',
                                          fontSize: 15,
                                          color: const Color(0xffB8B8B0),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        MessageStream(),
                        Visibility(
                          visible: _showBottomAppBar,
                          child: Positioned(

                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: BottomAppBar(

                              color: Color(0xfffffffc),
                              child: Container(

                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(7, 0, 0, 2),
                                      padding: EdgeInsets.all(0),
                                      width: 30.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.attach_file,
                                          size: 22,
                                        ),
                                        color: myColors.bottomBarIcons,
                                        onPressed: () async {
                                          print('attach');
                                          List<File> files = await FilePicker.getMultiFile(
                                            type: FileType.custom,
                                            allowedExtensions: [ 'pdf', 'doc'],
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      width: 30.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.image,
                                          size: 22,
                                        ),
                                        color: myColors.bottomBarIcons,
                                        onPressed: () async {
                                          print('Image');
                                          List<File> files = await FilePicker.getMultiFile(
                                            type: FileType.custom,
                                            allowedExtensions: [ 'jpg'],
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      width: 30.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: 22,
                                        ),
                                        color: myColors.bottomBarIcons,
                                        onPressed: () async {
                                          print('camera');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TakePictureScreen(
                                                  camera: firstCamera,)
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      width: 30.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.mic,
                                          size: 24,
                                        ),
                                        color: myColors.bottomBarIcons,
                                        onPressed: () {
                                          print('mic');
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(38.0),
                                          color: const Color(0xfff7f7f7),
                                          border: Border.all(
                                              width: 0.3, color: const Color(0xff707070)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 175,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  controller: msgController,

                                                  style: TextStyle(
                                                    fontFamily: 'Oxygen',
                                                    fontSize: 15,
                                                    color: Colors.black,

                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hoverColor: Colors.yellow,
                                                    hintText: 'Write your message here',
                                                    hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: const Color(0xffa0a0a0),

                                                    ),
                                                  ),
                                                  maxLines: null,
                                                  keyboardType: TextInputType.text,

                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      padding: EdgeInsets.all(0),
                                      width: 20.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.send,
                                          size: 24,
                                        ),
                                        color: myColors.appBar,
                                        onPressed:()
                                        {
                                          sendMessage(msgController.text.toString());
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ),
                        ),
                      ],
                    ),


            )
    );
  }

  Future<void> onJoin() async {
    ChatController().sendMessage(channel_id, receiver, 'videocall');
    // update input validation
    setState(() {
    });

      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channel_id,
            role: _role,
          ),
        ),
      );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  void sendMessage(String text)
  {
    ChatController chatController = new ChatController();
    chatController.sendMessage(text,receiver,'text');
  }
}

void _navigateToBackScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
    // Fill this out in the next steps.
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    File file = new File(imagePath);

    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Column(
        children: <Widget>[
          Image.file(file),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: ()
            {
              ChatController().sendImage(file, receiver);
//              ChatController().sendMessage(imagePath, receiver,'image');
            },
          )
        ],
      )
    );
  }
}

class MessageBubble extends StatelessWidget{

  MessageBubble({this.text,this.Sender, this.isMe});

  var Sender,text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(Sender.toString()),
          Material(
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ) : BorderRadius.only(topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text('$text',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),

          ),
        ],
      )
    );
  }
}
class ImageBubble extends StatelessWidget{

  ImageBubble({this.imagePath,this.Sender, this.isMe});

  var Sender,imagePath;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
          children: <Widget>[
            Text(Sender.toString()),
            Material(
              borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ) : BorderRadius.only(topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Image.network(imagePath),
              ),

            ),
          ],
        )
    );
  }
}

class MessageStream extends StatelessWidget{

  ClientRole _role = ClientRole.Broadcaster;

  MessageStream();

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(

      stream: Firestore.instance
          .collection('chat')
          .document(uid.toString())
          .collection(receiver.toString())
//          .orderBy('time',descending: true)
          .snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData)
        {
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageWidgets = [];
          for(var message in  messages)
          {
            final msgText = message.data['text'];
            final msgSender = message.data['senderID'];
            final msgType = message.data['type'];

            var msgBubble;

            print('User id: ${uid.toString()}');
            print('Receiver id: ${receiver.toString()}');
            print('User Email: ${uemail.toString()}');

            if(msgType == 'image')
            {
              msgBubble = ImageBubble(imagePath: msgText,Sender: msgSender,isMe: msgSender == uemail.toString());
            }

            else if(msgType == 'text')
            {
              msgBubble = MessageBubble(text: msgText,Sender: msgSender, isMe: msgSender == uemail.toString());
            }

            else if(msgType == 'videocall')
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: ClipOval(
                                //borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  receiver_pic,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text(
                                receiver_name,
                                style: TextStyle(
                                  fontFamily: 'Oxygen',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.only(right: 10),
                                  onPressed:  ()
                                  async {
                                    // update input validation


                                    // await for camera and mic permissions before pushing video page
                                    await _handleCameraAndMic();
                                    // push video page with given channel name
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CallPage(
                                          channelName: channel_id,
                                          role: _role,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 143.0,
                                    height: 41.0,
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color(0xff26B14D),
                                    ),
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                        fontFamily: 'Josefin Sans',
                                        fontSize: 22,
                                        color: const Color(0xffffffff),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  padding: EdgeInsets.only(right: 0),
                                  onPressed: null,
                                  child: Container(
                                    width: 143.0,
                                    height: 41.0,
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color(0xffDD4F43),
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                        fontFamily: 'Josefin Sans',
                                        fontSize: 22,
                                        color: const Color(0xffffffff),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            channel_id = msgText;
            }

            else if(msgType == 'voicecall')
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: ClipOval(
                                //borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  receiver_pic,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text(
                                receiver_name,
                                style: TextStyle(
                                  fontFamily: 'Oxygen',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.only(right: 10),
                                  onPressed:  ()
                                  {
                                    MaterialPageRoute(
                                      builder: (context) => VoiceCallPage(),
                                    );
                                  },
                                  child: Container(
                                    width: 143.0,
                                    height: 41.0,
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color(0xff26B14D),
                                    ),
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                        fontFamily: 'Josefin Sans',
                                        fontSize: 22,
                                        color: const Color(0xffffffff),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  padding: EdgeInsets.only(right: 0),
                                  onPressed: null,
                                  child: Container(
                                    width: 143.0,
                                    height: 41.0,
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color(0xffDD4F43),
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                        fontFamily: 'Josefin Sans',
                                        fontSize: 22,
                                        color: const Color(0xffffffff),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
              channel_id = msgText;
            }

            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child : ListView(
              reverse: true,
              children:  messageWidgets,
            ),
          );
        }
        else
        {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }


}

class VoiceCallPage extends StatefulWidget {
  @override
  _VoiceCallPageState createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';


  void startTimmer() {
    var oneSec = Duration(seconds: 1);
    _timmerInstance = Timer.periodic(
        oneSec,
            (Timer timer) => setState(() {
          if (_start < 0) {
            _timmerInstance.cancel();
          } else {
            _start = _start + 1;
            _timmer = getTimerTime(_start);
          }
        }));
  }


  String getTimerTime(int start) {
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes.toString().length == 1) {
      sMinute = '0' + minutes.toString();
    } else
      sMinute = minutes.toString();

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds.toString().length == 1) {
      sSeconds = '0' + seconds.toString();
    } else
      sSeconds = seconds.toString();

    return sMinute + ':' + sSeconds;
  }

  @override
  void initState() {
    super.initState();
    startTimmer();
  }

  @override
  void dispose() {
    _timmerInstance.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Text(
                'VOICE CALL',
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                receiver_name,
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                _timmer,
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: 20.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(200.0),
                child: Image.network(
                  receiver_pic,
                  height: 200.0,
                  width: 200.0,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FunctionalButton(
                    title: 'Speaker',
                    icon: Icons.phone_in_talk,
                    onPressed: () {},
                  ),
                  FunctionalButton(
                    title: 'Video Call',
                    icon: Icons.videocam,
                    onPressed: () {},
                  ),
                  FunctionalButton(
                    title: 'Mute',
                    icon: Icons.mic_off,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(
                height: 120.0,
              ),
              FloatingActionButton(
                onPressed: () {},
                elevation: 20.0,
                shape: CircleBorder(side: BorderSide(color: Colors.red)),
                mini: false,
                child: Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
                backgroundColor: Colors.red[100],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FunctionalButton extends StatefulWidget {
  final title;
  final icon;
  final Function() onPressed;

  const FunctionalButton({Key key, this.title, this.icon, this.onPressed})
      : super(key: key);

  @override
  _FunctionalButtonState createState() => _FunctionalButtonState();
}

class _FunctionalButtonState extends State<FunctionalButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RawMaterialButton(
          onPressed: widget.onPressed,
          splashColor: Colors.deepPurpleAccent,
          fillColor: Colors.white,
          elevation: 10.0,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              widget.icon,
              size: 30.0,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 15.0, color: Colors.deepPurpleAccent),
          ),
        )
      ],
    );
  }
}

