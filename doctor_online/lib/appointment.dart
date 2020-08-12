import 'package:doctorapp/set_appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/appointment_class.dart';
import 'Controllers/ShowDoctorController.dart';
import 'appointment_class.dart';
import 'Chat_List.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PatientViewDoctors extends StatelessWidget {
  //String email;
  //SetupProfile(this.email);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    debugShowCheckedModeBanner:
    false;
    return MaterialApp(
      home: new _PatientViewDoctors_(),
    );
  }
}

class _PatientViewDoctors_ extends StatefulWidget {
  // String email;
  // _SetupProfile_(this.email);
  @override
  State<StatefulWidget> createState() => _PatientViewDoctors();
}

class _PatientViewDoctors extends State<_PatientViewDoctors_> {
  List<appointment_class> apt;

  ValueNotifier<bool> _isSearchFetched = ValueNotifier(false);
  void setStateOfList(List<appointment_class> myList) {
    setState(() {
      if (myList != null) apt = myList;
    });
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    apt = ShowDoctorController().getDoctorAppointments() as List<appointment_class>;
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // apt = [
    //   appointment_class(
    //     doctor_name: 'John',
    //     age: '54',
    //     profile_pic: 'images/man_pic.jpg',
    //     field: 'Physiologist',
    //     contact_hours: '10am - 5pm',
    //     rating: 5,
    //   ),
    //   appointment_class(
    //     doctor_name: 'John',
    //     age: '54',
    //     profile_pic: 'images/man_pic.jpg',
    //     field: 'Eye Specialist',
    //     contact_hours: '10am - 5pm',
    //     rating: 3,
    //   ),
    //   appointment_class(
    //     doctor_name: 'John',
    //     age: '54',
    //     profile_pic: 'images/man_pic.jpg',
    //     field: 'Dentist',
    //     contact_hours: '10am - 5pm',
    //     rating: 4,
    //   ),
    //   appointment_class(
    //     doctor_name: 'John',
    //     age: '54',
    //     profile_pic: 'images/man_pic.jpg',
    //     field: 'Cardiologist',
    //     contact_hours: '10am - 5pm',
    //     rating: 3,
    //   ),
    // ];
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // routes: <String, WidgetBuilder>{
      //   '/setAppointment': (BuildContext context) => new set_appointment(),
      // },
      theme: ThemeData(
        primaryColor: Color(0xFF4E45FF),
        accentColor: Color(0xFF4E45FF),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Naija Dentist',
            style: TextStyle(
              fontFamily: 'Oxygen',
            ),
          ),
          actions: <Widget>
          [
            IconButton(
              icon: Icon(Icons.message),
              onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatList(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 30,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 3),
              decoration: BoxDecoration(color: Color(0xFF4E45FF)),
              child: FlatButton(
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontFamily: 'Oxygen',
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  await searchAppointmentRecords().then((value) {
                    setState(() {
                      _isSearchFetched.value = true;
                    });
                  });
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _isSearchFetched,
              builder: (BuildContext context, bool value, Widget child) {
                print('hello');
                if (value == false) {
                  return Text('Nothing Searched');
                } else {
                  print('apt len ${apt.length}');
                  return (apt != null)
                      ? Flexible(
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            footer: CustomFooter(
                              builder: (BuildContext context,LoadStatus mode){
                                Widget body ;
                                if(mode==LoadStatus.idle){
                                  body =  Text("pull up load");
                                }
                                else if(mode==LoadStatus.loading){
                                  body =  CupertinoActivityIndicator();
                                }
                                else if(mode == LoadStatus.failed){
                                  body = Text("Load Failed!Click retry!");
                                }
                                else if(mode == LoadStatus.canLoading){
                                  body = Text("release to load more");
                                }
                                else{
                                  body = Text("No more Data");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child:body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: apt.length,
                              itemBuilder: (BuildContext context, int index) {
                                var temp_apt = apt.elementAt(index);
                                return InkWell(
                                  child: Container(
                                      constraints: BoxConstraints(
                                        minWidth: 150,
                                        maxWidth:
                                        MediaQuery.of(context).size.width -
                                            40,
                                      ),
                                      margin:
                                      EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  padding: EdgeInsets.all(10),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        80.0),
                                                    child: Image.network(
                                                      temp_apt.uploadedFileURL,
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      height: 80.0,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 200,
                                                      child: Text(
                                                        'Name: ${temp_apt.doctor_name}',
                                                        style: TextStyle(
                                                          fontFamily: 'Oxygen',
                                                          fontSize: 20,
                                                        ),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Description: ${temp_apt.Description}',
                                                        style: TextStyle(
                                                          fontFamily: 'Oxygen',
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                        TextAlign.center,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Year Of Practice: ${temp_apt.YOP}',
                                                        style: TextStyle(
                                                          fontFamily: 'Oxygen',
                                                          fontSize: 15,
                                                        ),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Office Address: ${temp_apt.OAddress}',
                                                        style: TextStyle(
                                                          fontFamily: 'Oxygen',
                                                          fontSize: 15,
                                                        ),
                                                        textAlign:
                                                        TextAlign.center,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                    getRating(temp_apt.rating),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 35,
                                              margin: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF4E45FF)),
                                              child: FlatButton(
                                                child: Text(
                                                  'Set Appointment',
                                                  style: TextStyle(
                                                    fontFamily: 'Oxygen',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              set_appointment(temp_apt)));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                        )
                      : Center(
                          child: Text('No Record Exist'),
                        );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  getRating(var count) {
    List<Widget> list = new List<Widget>();
    if (count != null) {
      for (var i = 0; i < int.parse(count.toString()); i++) {
        list.add(new Icon(Icons.star));
      }
    }
    return new Row(children: list);
  }

  Future searchAppointmentRecords() async {
    ShowDoctorController showDoctorController = new ShowDoctorController();

    List<appointment_class> myList =
        await showDoctorController.getDoctorAppointments();
    print("Doctor Appointment list len ${myList.length}");
    setStateOfList(myList);
  }
}
