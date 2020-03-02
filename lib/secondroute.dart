import 'package:flutter/material.dart';
import 'package:flutter_app2/services.dart';
import 'package:flutter_app2/boreddata.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SecondRoute extends StatefulWidget {
  SecondRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

enum BoringActivity {
  education,
  recreational,
  social,
  diy,
  charity,
  cooking,
  relaxation,
  music,
  busywork
}

class _SecondRouteState extends State<SecondRoute> {
  BoringActivity _boringactivity = BoringActivity.education;
  double _price = 0.0;
  double _accessibility = 0.0;
  int _participants = 0;
  Future<BoredData> _boredData;

  void _getBoredActivity() {
    //setState(() {
      String activityValue = _boringactivity.toString().split('.').last;
      _boredData = getRandomActivityFor(
          activityValue, _price, _accessibility, _participants);
      _showActivity();
    //});
  }

  void _showActivity() {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return     AlertDialog(
            title: Text('We suggest you to:'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FutureBuilder<BoredData>(
                    future: _boredData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.error == null) {
                        return Text(snapshot.data.activity);
                      } else if (snapshot.hasData && snapshot.data.error != null) {
                        return Text(snapshot.data.error);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Text("");
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Join'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    final captionTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 15,
    );
    
    return Scaffold(
      appBar: AppBar(
          title: Text("Okay, Lets find an activity for you"),
          actions: <Widget>[]),
      body: Container(
        padding: EdgeInsets.only(top:10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('Type of activity', style: captionTextStyle),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.education,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('Education'),
          ]),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.recreational,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('Recreation'),
          ]),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.music,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('Music'),
          ]),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.cooking,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('Cooking'),
          ]),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.relaxation,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('Relaxation'),
          ]),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.diy,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('DIY'),
          ]),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.busywork,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('Busy Work'),
          ]),
          Row(children: <Widget>[
            Radio(
                value: BoringActivity.social,
                groupValue: _boringactivity,
                onChanged: (BoringActivity value) {
                  setState(() {
                    _boringactivity = value;
                  });
                }),
            Text('Social'),
          ]),
          Text('Price Range',  style: captionTextStyle),
          Slider(
              value: _price,
              min: 0,
              max: 1,
              divisions: 10,
              activeColor: Colors.blue,
              inactiveColor: Colors.blueGrey,
              label: _price.toString(),
              onChanged: (double newValue) {
                setState(() {
                  _price = newValue;
                });
              },
              semanticFormatterCallback: (double newValue) {
                return '$newValue';
              }),
          Text('Accessibility Range', style: captionTextStyle),
          Slider(
              value: _accessibility,
              min: 0,
              max: 1,
              divisions: 10,
              activeColor: Colors.blue,
              inactiveColor: Colors.blueGrey,
              label: _accessibility.toString(),
              onChanged: (double newValue) {
                setState(() {
                  _accessibility = newValue;
                });
              },
              semanticFormatterCallback: (double newValue) {
                return '$newValue';
              }),
          Text('Number of participants', style: captionTextStyle),
          Slider(
              value: _participants.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              activeColor: Colors.blue,
              inactiveColor: Colors.blueGrey,
              label: _participants.toString(),
              onChanged: (double newValue) {
                setState(() {
                  _participants = newValue.ceil();
                });
              },
              semanticFormatterCallback: (double newValue) {
                return '$newValue';
              }),
          FlatButton(
            onPressed: _getBoredActivity,
            color: Colors.blue,
            textColor: Colors.white,
            child: Text("Find activity"),
          ),
        ],
      )),
    );
  }
}
