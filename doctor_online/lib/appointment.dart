import 'package:doctorapp/set_appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/appointment_class.dart';
import 'appointment_class.dart';

class appointment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<appointment_class> apt = [
      appointment_class(
        doctor_name: 'John',
        age: '54',
        profile_pic: 'images/man_pic.jpg',
        field: 'Physiologist',
        contact_hours: '10am - 5pm',
        rating: 5,
      ),

      appointment_class(
        doctor_name: 'John',
        age: '54',
        profile_pic: 'images/man_pic.jpg',
        field:'Eye Specialist',
        contact_hours: '10am - 5pm',
        rating: 3,
      ),

      appointment_class(
        doctor_name: 'John',
        age: '54',
        profile_pic: 'images/man_pic.jpg',
        field: 'Dentist',
        contact_hours: '10am - 5pm',
        rating: 4,
      ),

      appointment_class(
        doctor_name: 'John',
        age: '54',
        profile_pic: 'images/man_pic.jpg',
        field: 'Cardiologist',
        contact_hours: '10am - 5pm',
        rating: 3,
      ),
    ];

    // TODO: implement build
    return MaterialApp(

      debugShowCheckedModeBanner: false,
        routes: <String,WidgetBuilder>{
        '/setAppointment':(BuildContext context)=> new set_appointment(),
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
            Flexible(
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
                                  minWidth: 350,
                                  maxWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 40,
                                ),

                                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width:150,
                                              height: 150,
                                              padding: EdgeInsets.all(10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20.0),
                                                child: Image.asset(
                                                  temp_apt.profile_pic,
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 200.0,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),

                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  width:200,

                                                  child:
                                                  Text(
                                                    'Name: '+temp_apt.doctor_name,
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 20,
                                                    ),
                                                    overflow: TextOverflow.visible,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  child:
                                                  Text(
                                                    'Age: '+temp_apt.age,
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.visible,
                                                  ),
                                                ),
                                                Container(
                                                  child:
                                                  Text(
                                                    'Specialization: '+temp_apt.field,
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 15,
                                                    ),
                                                    overflow: TextOverflow.visible,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Contact Hrs: '+temp_apt.contact_hours,
                                                    style: TextStyle(
                                                      fontFamily: 'Oxygen',
                                                      fontSize: 15,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.visible,
                                                  ),
                                                ),
                                                getRating(temp_apt.rating),

                                              ],
                                            )
                                          ],

                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF4E45FF)
                                          ),
                                          child: FlatButton(
                                            child: Text(
                                              'Set Appointment',
                                              style: TextStyle(
                                                fontFamily: 'Oxygen',
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: (){
                                              Navigator.of(context).pushNamed('/setAppointment');
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                )
                            ),
                          );
                        },),),),
          ],
        ),
      ),
    );
  }

  getRating(int count){
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < count; i++){
      list.add(new Icon(Icons.star));
    }
    return new Row(children: list);
  }

}