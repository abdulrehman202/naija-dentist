import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(set_appointment());
}

class set_appointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _set_appontment(),
    );
  }
}

class _set_appontment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _set_appontment_();
}

class _set_appontment_ extends State<_set_appontment> {
  int _communicationOption = 0, _rateOption = 0;
  int _5m = 3, _10m = 7, _15m = 10, _20m = 15, _30m = 20, _1h = 30;

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> communicationOptionList = ['Audio', 'Video', 'Live Chat'];
    List<String> rateList = [
      '5 minutes: \$' + this._5m.toString(),
      '10 minutes: \$' + this._10m.toString(),
      '15 minutes: \$' + this._15m.toString(),
      '20 minutes: \$' + this._20m.toString(),
      '30 minutes: \$' + this._30m.toString(),
      '1 hour: \$' + this._1h.toString(),
    ];
    String chosen_communication = '';

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
                margin: EdgeInsets.fromLTRB(10.0, 0, 0, 5),
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
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'images/man_pic.jpg',
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Dr. Tokyo',
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 25,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Container(
                            child: Text(
                              'Dentist',
                              style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          getRating(5),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 27,
                margin: EdgeInsets.only(left: 10),
                child: TextField(
                  readOnly: true,
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

                      myController.text = "Date: $day-$month-$year";
                    });
                  },
                  controller: myController,
                  showCursor: false,
                  maxLines: 1,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Choose Date'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    DateTime now = DateTime.now();
                    showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay(hour: now.hour, minute: now.minute),
                    ).then((value) {
                      myController2.text = "Time: ${value.format(context)}";
                    });
                  },
                  controller: myController2,
                  showCursor: false,
                  maxLines: 1,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Choose Time'),
                ),
              ),
              Container(
                height: 18,
                margin: EdgeInsets.only(left: 15, top: 0),
                child: Text(
                  'Choose communication option',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Oxygen',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Column(
                children: [0, 1, 2]
                    .map(
                      (e) => Container(
                        height: 31,
                        child: RadioListTile(
                          title: Container(
                              child: Text(communicationOptionList[e])),
                          value: e,
                          groupValue: _communicationOption,
                          onChanged: (int val) {
                            setState(() {
                              chosen_communication =
                                  communicationOptionList[val];
                              this._communicationOption = val;
                              setRates(val);
                              print(chosen_communication);
                              //TODO: choose communication method
                            });
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  'Rates',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Oxygen',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Column(
                children: [0, 1, 2, 3, 4, 5]
                    .map((e) => Container(
                          height: 32,
                          child: RadioListTile(
                            title: Text(rateList[e]),
                            value: e,
                            groupValue: _rateOption,
                            onChanged: (int val) {
                              setState(() {
                                this._rateOption = val;
                                //TODO: choose communication method
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getRating(int count) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < count; i++) {
      list.add(new Icon(Icons.star));
    }
    return new Row(children: list);
  }

  setRates(int chosenOption) {
    if (chosenOption == 0) {
      this._5m = 3;
      this._10m = 7;
      this._15m = 10;
      this._20m = 15;
      this._30m = 20;
      this._1h = 35;
    } else if (chosenOption == 1) {
      this._5m = 5;
      this._10m = 10;
      this._15m = 15;
      this._20m = 20;
      this._30m = 30;
      this._1h = 45;
    } else if (chosenOption == 2) {
      this._5m = 1;
      this._10m = 3;
      this._15m = 7;
      this._20m = 10;
      this._30m = 15;
      this._1h = 30;
    }
  }
}
