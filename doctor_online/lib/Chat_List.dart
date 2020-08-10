import 'package:doctorapp/Classes/DoctorAppointments.dart';
import 'package:doctorapp/WColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/main.dart';

class ChatList extends StatelessWidget {
  DoctorAppointments obj;
  ChatList(this.obj);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        //'/signup': (BuildContext context) => new SignupPage(),
      },
      home: new ChatListPage(obj),
    );
  }
}

class ChatListPage extends StatefulWidget {
  DoctorAppointments obj;
  ChatListPage(this.obj);
  @override
  _ChatListPageState createState() => new _ChatListPageState(obj);
}

class _ChatListPageState extends State<ChatListPage> {
  MediaQueryData queryData;
  WColors wColors;
  DoctorAppointments obj;
  _ChatListPageState(this.obj);
  static List<String> Names = [
    'Professor',
    'Nairobi',
    'Tokyo',
    'Berlin',
  ];

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    wColors = new WColors();
    var widthD = queryData.size.width;
    var heightD = queryData.size.height;
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: wColors.appBar,
        title: Row(
          children: <Widget>[
            GestureDetector(
              child: Container(
                child: Icon(Icons.arrow_back, color: wColors.appBarIcons),
                alignment: Alignment.topLeft,
                width: 40,
              ),
              onTap: () {
                _navigateToBackScreen(context);
              },
            ),
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
                'Chats',
                style: TextStyle(
                  fontFamily: 'Oxygen',
                  fontSize: 18,
                  color: wColors.appBarText,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          Container(
            child: Icon(
              Icons.more_vert,
              color: wColors.appBarIcons,
            ),
            alignment: Alignment.center,
            width: 45,
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      backgroundColor: const Color(0xffffffff),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  //width: 250,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 40, maxHeight: 100),
                    alignment: Alignment.center,
                    child: TextField(
                      expands: true,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      maxLines: null,
                      style: TextStyle(
                        fontFamily: 'Oxygen',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: 20.0,
                          color: const Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            margin: EdgeInsets.all(25),
            alignment: Alignment.center,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: const Color(0xfff7f7f7),
              border: Border.all(width: 0.3, color: const Color(0xff707070)),
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: Names.length,
              itemBuilder: (context, index) {
                var title = Names.elementAt(index);
                return Card(
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(3.0),
                                child: Image.asset('images/man_pic.jpg')),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /*Name*/
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 16,
                                color: const Color(0xff727272),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),

                            /*Status*/
                            Text(
                              'Hey there! How are you',
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 14,
                                color: const Color(0xff727272),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.centerRight,
                            child: Text(
                              '30 min ago',
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 14,
                                color: const Color(0xff727272),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _navigateToBackScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
}
