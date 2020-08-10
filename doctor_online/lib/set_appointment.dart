import 'dart:ui';
import 'package:doctorapp/appointment_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Classes/SetAppointment.dart';
import 'Controllers/SetAppointmentController.dart';

class set_appointment extends StatelessWidget {
  appointment_class obj;
  set_appointment(this.obj);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _set_appontment(obj),
    );
  }
}

class _set_appontment extends StatefulWidget {
  appointment_class obj;
  _set_appontment(this.obj);
  @override
  State<StatefulWidget> createState() => _set_appontment_(obj);
}

class _set_appontment_ extends State<_set_appontment> {
   appointment_class obj;
  _set_appontment_(this.obj);
  
  static int _5m = 3, _10m = 7, _15m = 10, _20m = 15, _30m = 20, _1h = 30;

  static const communicationOptionList = <String>[
    'Audio',
    'Video',
    'Live Chat'
  ];
  final List<DropdownMenuItem<String>> dropdown_communicationOptionList =
      communicationOptionList
          .map(
            (String e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList();

  List<String> audioRate = [
    '5 minutes: \$ 3',
    '10 minutes: \$ 7',
    '15 minutes: \$ 10',
    '20 minutes: \$ 15',
    '30 minutes: \$ 20',
    '1 hour: \$ 35',
  ];

  String chosenMethod = 'Audio', chosenRate, chosenDate, chosenTime;

  static List<String> list_Rate;

  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    list_Rate = audioRate;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Book your Appointment'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 40, 10, 10),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 10,
                ),
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'images/man_pic.jpg',
                            height: 150.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${obj.doctor_name}',
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 25,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Container(
                            child: Text(
                              '${obj.Description}',
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          getRating(obj.rating),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Date:',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Oxygen',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        onChanged: (String value) {
                          chosenDate = value;
                        },
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
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Time:',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Oxygen',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        onTap: () {
                          DateTime now = DateTime.now();
                          showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay(hour: now.hour, minute: now.minute),
                          ).then((value) {
                            timeController.text = "${value.format(context)}";
                          });
                        },
                        controller: timeController,
                        showCursor: false,
                        maxLines: 1,
                        decoration:
                            InputDecoration.collapsed(hintText: 'Choose Time'),
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Communication:',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Oxygen',
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.only(left: 3),
                      child: DropdownButton<String>(
                        value: chosenMethod,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            chosenMethod = newValue;

                            if (chosenRate != null) chosenRate = null;

                            if (newValue == "Audio") {
                              list_Rate.clear();
                              list_Rate.add('5 minutes: \$ 3');
                              list_Rate.add('10 minutes: \$ 7');
                              list_Rate.add('15 minutes: \$ 10');
                              list_Rate.add('20 minutes: \$ 15');
                              list_Rate.add('30 minutes: \$ 20');
                              list_Rate.add('1 hour: \$ 35');
                            } else if (newValue == "Video") {
                              list_Rate.clear();
                              list_Rate.add('5 minutes: \$ 5');
                              list_Rate.add('10 minutes: \$ 10');
                              list_Rate.add('15 minutes: \$ 15');
                              list_Rate.add('20 minutes: \$ 20');
                              list_Rate.add('30 minutes: \$ 30');
                              list_Rate.add('1 hour: \$ 45');
                            } else if (newValue == "Live Chat") {
                              list_Rate.clear();
                              list_Rate.add('5 minutes: \$ 1');
                              list_Rate.add('10 minutes: \$ 3');
                              list_Rate.add('15 minutes: \$ 7');
                              list_Rate.add('20 minutes: \$ 10');
                              list_Rate.add('30 minutes: \$ 15');
                              list_Rate.add('1 hour: \$ 30');
                            }
                          });
                        },
                        items: communicationOptionList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Oxygen',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ]),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Rates:',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Oxygen',
                      ),
                    ),
                  ),
                  Align(
                    child: Container(
                      padding: EdgeInsets.only(left: 85),
                      child: DropdownButton<String>(
                        value: chosenRate,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            chosenRate = newValue;
                          });
                        },
                        items: list_Rate
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Oxygen',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(color: Color(0xFF4E45FF)),
                  child: FlatButton(
                    child: Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontFamily: 'Oxygen',
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      print('okay');
                      SetAppointmentController controller =
                          new SetAppointmentController();
                      SetAppointmentClass c = new SetAppointmentClass(
                          dateController.text, timeController.text,chosenMethod,chosenRate);

                      controller.AddPatientsRecords(c,obj.doctorID);
                    },
                  ),
                ),
              ),
            ],
          ),
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
}
