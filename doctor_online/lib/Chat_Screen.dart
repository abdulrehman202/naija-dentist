import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/main.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:doctorapp/WColors.dart';
import 'package:doctorapp/Controllers/ChatController.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

var firstCamera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  firstCamera = cameras.first;

  runApp(ChatScreen());
}

@protected


class ChatScreen extends StatelessWidget {
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

  MediaQueryData queryData;
  WColors myColors;
  var msgController = new TextEditingController();
  Category category;
  OnEmojiSelected onEmojiSelected;

  var _showBottomAppBar = false;

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
                            sendMessage();
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
                      child: Image.asset(
                        'images/man_pic.jpg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(13, 0, 0, 0),
                    child: Text(
                      'Linda',
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.videocam,
                    size: 24,
                  ),
                  color: myColors.appBarIcons,
                  onPressed: () {},
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

              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    //physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 15,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(3.0),
                                child: Image.asset('images/man_pic.jpg')),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: 75, maxWidth: widthD - 175),
                              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Color(0xfff5f5f5),
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Hello!fdddddddddddddddddddddddddddddddddddddddddd',
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
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: 100, maxWidth: widthD - 175),
                              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              margin: EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                color: myColors.appBar,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Hello!',
                                maxLines: null,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontFamily: 'Oxygen',
                                  fontSize: 16,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(3.0),
                                child: Image.asset('images/man_pic.jpg')),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                                    sendMessage();
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
            ));

  }

  void sendMessage()
  {
    ChatController chatController = new ChatController();
    chatController.sendMessage(1, 2, msgController.text.toString());
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
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}