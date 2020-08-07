import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ProfileClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff7755a4),
      ),
      home: _ProfileClass(),
    );
  }
}

class _ProfileClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Profile();
}

class Profile extends State<_ProfileClass> {
  int _currentTabIndex = 0;

//TODO: Bottom Navigation Bar
  @override
  Widget build(BuildContext context) {
    final _pages = <Widget>[
      SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(color: Color(0xff4e45ff)),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 20, 10, 10),
                      child: Builder(builder: (BuildContext innerContext) {
                        return IconButton(
                            icon: Icon(
                              Icons.short_text,
                              color: const Color(0xffffffff),
                              size: 50,
                            ),
                            onPressed: () {
                              Scaffold.of(innerContext).openDrawer();
                            });
                      })),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      cursorColor: const Color(0xffffffff),
                      style: TextStyle(fontSize: 16,fontFamily: 'Oxygen'),
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: 'What do you want to Search?',
                        labelStyle: TextStyle(color: Color(0xffffffff)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                      ),
                      onSubmitted: (val) {
                        //TODO: search text
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 40, 23, 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.comment,
                        color: const Color(0xffffffff),
                        size: 30,
                      ),
                      onPressed: () {
                        //TODO: Open messages
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: new BoxDecoration(color: Color(0xff4e45ff)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(130.0),
                      child: Image.asset("images/man_pic.jpg"),
//                  padding: new EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Center(child: Text('Market')),
      Center(child: Text('Settings')),
      Center(child: Text('Search')),
    ];

    final barItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Setting'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search'),
      ),
    ];

    final bottomNavBar = BottomNavigationBar(
      items: barItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: Drawer(
        child: Container(
          color: const Color(0xff5d4b86),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Color(0xff5d4b86)),

                  // currentAccountPicture: CircleAvatar(backgroundImage: ExactAssetImage("assets/header.jpg"),),
                  currentAccountPicture: new CircleAvatar(
                    radius: 100,
                    backgroundColor: const Color(0xFF778899),
                    child: Image.asset("images/header.jpg"),
                  ),
                  accountName: Text(
                    "Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    "Surname",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              ListTile(
                title: Text(
                  "Profile",
                  style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  //your code here
                },
              ),
              ListTile(
                title: Text(
                  "Settings",
                  style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  //your code here
                },
              ),
              ListTile(
                title: Text(
                  "Post & Trips",
                  style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  //your code here
                },
              ),
            ],
          ),
        ),
      ),
      body: _pages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}

