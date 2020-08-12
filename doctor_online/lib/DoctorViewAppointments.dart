import 'package:doctorapp/Chat_List.dart';
import 'package:doctorapp/Chat_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Chat_Screen.dart';
import 'Classes/DoctorAppointments.dart';
import 'package:chips_choice/chips_choice.dart';

import 'Controllers/DoctorAppointmentController.dart';

class DoctorViewAppointments extends StatelessWidget {
  //String email;
  //SetupProfile(this.email);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    debugShowCheckedModeBanner:
    false;
    return MaterialApp(
      home: new _DoctorAppointment_(),
    );
  }
}

class _DoctorAppointment_ extends StatefulWidget {
  // String email;
  // _SetupProfile_(this.email);
  @override
  State<StatefulWidget> createState() => DoctorViewAppointment();
}

class DoctorViewAppointment extends State<_DoctorAppointment_> {
  int tag = 0;
  List<String> options = ['Selected Date', 'All Time'];
  DoctorViewAppointment obj;
  var dateController = new TextEditingController();
  List<DoctorAppointments> apt;
  ValueNotifier<bool> _isSearchFetched = ValueNotifier(false);
  void setStateOfList(List<DoctorAppointments> myList) {
    setState(() {
      if (myList != null) apt = myList;
    });
  }

  @override
  Widget build(BuildContext context) {
    dateController.text = '';
    obj = this;
    // apt = [
    //   DoctorAppointments(
    //       patientId: '5656565',
    //       name: 'John',
    //       age: '54',
    //       date: '7-Aug-2012',
    //       time: '12-10',
    //       communication: 'audio'),
    //   DoctorAppointments(
    //       patientId: '5656565',
    //       name: 'Ahmad',
    //       age: '56',
    //       date: '7-Aug-2012',
    //       time: '12-10',
    //       communication: 'audio'),
    //   DoctorAppointments(
    //       patientId: '5656565',
    //       name: 'Akram',
    //       age: '54',
    //       date: '7-Aug-2012',
    //       time: '12-10',
    //       communication: 'audio'),
    // ];
    DateTime date = DateTime.now();
    dateController.text = date.day.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.year.toString();
    //searchAppointmentRecords();
    print(apt);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
//        '/startChat': (BuildContext context) => new ChatScreen(),
      },
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
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 75),
                  child: Text(
                    'Date:',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Oxygen',
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  margin: EdgeInsets.only(left: 10),
                  child: TextField(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        String day = value.day.toString();
                        String month = value.month.toString();
                        String year = value.year.toString();

                        dateController.text = "$day-$month-$year";
                      });
                    },
                    controller: dateController,
                    showCursor: false,
                    maxLines: 1,
                    decoration:
                        InputDecoration.collapsed(hintText: 'Choose Date'),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            ChipsChoice.single(
              value: tag,
              options: ChipsChoiceOption.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
              onChanged: (val) => setState(() => tag = val),
            ),
            Container(
              height: 30,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
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
                          child: SingleChildScrollView(
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
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Card(
                                      child: Row(
                                        children: <Widget>[
                                          temp_apt.uploadedFileURL != null
                                              ? Container(
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
                                                      height: 80,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          Center(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                    'Name: ${temp_apt.name}',
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 20,
                                                    ),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Age: ${temp_apt.age}',
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Appointment Date: ${temp_apt.date}',
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 15,
                                                    ),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Appointment Time: ${temp_apt.time}',
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 15,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Communcication: ${temp_apt.communication}',
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 15,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF4E45FF)),
                                                  child: FlatButton(
                                                    child: Text(
                                                      'Contact Patient',
                                                      style: TextStyle(
                                                        fontFamily: 'Oxygen',
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      print(index);
                                                      print(temp_apt.patientId);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChatScreen(temp_apt
                                                                    .patientId
                                                                    .toString())),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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

  Future searchAppointmentRecords() async {
    print(tag);
    if (dateController.text == '') {
      return;
    }
    DoctorAppointmentController doctorAppointmentController =
        new DoctorAppointmentController();
    if (tag == 0) {
      List<DoctorAppointments> myList = await doctorAppointmentController
          .getDoctorAppointments(dateController.text);
      print("Doctor Appointment list len ${myList.length}");
      setStateOfList(myList);
    } else {
      List<DoctorAppointments> myList =
          await doctorAppointmentController.getDoctorAppointmentsWithout();
      print("Doctor Appointment list len ${myList.length}");
      setStateOfList(myList);
    }
  }
}
