import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/secondroute.dart';
import 'package:flutter_app2/services.dart';
import 'package:flutter_app2/boreddata.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCC Coding Challenge',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: MyHomeRoute(title: 'BoredGram'),
    );
  }
}

class MyHomeRoute extends StatefulWidget {
  MyHomeRoute({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomeRouteState createState() => _MyHomeRouteState();
}

Future<BoredData> _boredData;
String _boredDataValue;
List<String> _upComingboredDataList = new List();
List<bool> _selectedDataList = new List();
List<String> _pastBoredDataList = new List();

class _MyHomeRouteState extends State<MyHomeRoute> {
  Future<BoredData> _boredData;
  final String _noConnectionMessage =
      "Please make sure you have an active interent connection";
  final String _featureNotImplemented = "Feature not implemented";
  final String _connectionTitle = "Internet Connection";
  final String _warningTitle = "Warning";

  final String _pastActivitiesTitle = "Your past activities";
  final String _pastActivitiesMessage = "1)Learn Calligrapy "
      "\n2)Bake bread from scratch";

  /**
   * Calls the boring api to fetch a random activity
   * if an active internet connection is available
   * else shows an alert dialog
   */
  Future<int> _getBoredActivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _boredData = getRandomActivity();
      _showRandomActivity();
      return 1;
    }
    _showAlert(_connectionTitle, _noConnectionMessage);
    return 0;
  }

  /**
   * Opens a new route(screen) to allow the user
   * to select options to find a random activity
   */
  Future<int> _goToSecondRoute() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
     String activity= await  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondRoute()),
      );
      return 1;
    }
    _showAlert(_connectionTitle, _noConnectionMessage);
    return 0;
  }

  /**
   * Displays an alert with the given title and message
   */
  void _showAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(message)],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showFeatureNotImplementedAlert() {
    _showAlert(_warningTitle, _featureNotImplemented);
  }

  /**
   * Displays the list of activities that the user was interested in past
   * Not implemented
   * For testing displays dummy values
   */
  void _showPastActivities() {
    final titleTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 14,
      height: 2,
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
                  //width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Text('Your past activities:', style: titleTextStyle),
                      _buildPastEvents(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Close",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                          ),
                        ],
                      )

                    ],
                  )));
        });
  }


  Widget _buildPastEvents() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        itemCount: _pastBoredDataList.length,
        itemBuilder: /*1*/ (context, i) {
          return ListTile(
              title: Text(_pastBoredDataList[i])
          );
        });
  }
  /***
   * Displays the random activity details fetched
   * from the boring api in a dialog bo
   */
  void _showRandomActivity() {
    final descTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 14,
      height: 2,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Activity', style: descTextStyle),
                FutureBuilder<BoredData>(
                  future: _boredData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _boredDataValue = snapshot.data.activity;
                      return Text(snapshot.data.activity);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Text("");
                  },
                ),
                Text('Type', style: descTextStyle),
                FutureBuilder<BoredData>(
                  future: _boredData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.type);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Text("");
                  },
                ),
                Text('Price', style: descTextStyle),
                FutureBuilder<BoredData>(
                  future: _boredData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FlutterRatingBar(
                          initialRating: snapshot.data.price,
                          fillColor: Colors.blue,
                          borderColor: Colors.blue.withAlpha(50),
                          allowHalfRating: true,
                          onRatingUpdate: null);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Text("");
                  },
                ),
                Text('Accessibility', style: descTextStyle),
                FutureBuilder<BoredData>(
                  future: _boredData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FlutterRatingBar(
                          initialRating: snapshot.data.accessibility,
                          fillColor: Colors.blue,
                          borderColor: Colors.blue.withAlpha(50),
                          allowHalfRating: true,
                          onRatingUpdate: null);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Text("");
                  },
                ),
                Text('Participants', style: descTextStyle),
                FutureBuilder<BoredData>(
                  future: _boredData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data.participants > 1){
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                           Text(snapshot.data.participants.toString()),
                          Icon(Icons.people)
                          ],
                        );
                      }
                      if(snapshot.data.participants == 1) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(snapshot.data.participants.toString()),
                            Icon(Icons.person)
                          ],
                        );
                      }
                      return Text(snapshot.data.participants.toString());
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Text("");
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                    RaisedButton(
                      onPressed: () {
                        _upComingboredDataList.add(_boredDataValue);
                        _selectedDataList.add(false);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    )
                  ],
                )
              ],
            ),
          ));
        });
  }

  void _showUpcomingActivities() {
    final titleTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 14,
      height: 2,
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpComingEventsDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    final avatarTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 32,
    );

    final boreTextStyle = TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 14,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[]),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade800,
                child: Text(
                  'N',
                  style: avatarTextStyle,
                ),
                radius: 60,
              ),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: _showFeatureNotImplementedAlert,
                      color: Colors.blue,
                      child: Icon(Icons.contacts, color: Colors.white)),
                  FlatButton(
                      onPressed: _showFeatureNotImplementedAlert,
                      color: Colors.blue,
                      child: Icon(Icons.map, color: Colors.white)),
                  FlatButton(
                      onPressed: _showPastActivities,
                      color: Colors.blue,
                      child: Icon(Icons.alarm_off, color: Colors.white)),
                  FlatButton(
                      onPressed: _showUpcomingActivities,
                      color: Colors.blue,
                      child: Icon(Icons.alarm_on, color: Colors.white))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Today,I am feeling very bored...", style: boreTextStyle),
                Icon(Icons.sentiment_very_dissatisfied)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: _getBoredActivity,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Suggest me an activity"),
                ),
                FlatButton(
                  onPressed: _goToSecondRoute,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Help me find an activity"),
                )
              ],
            ),
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _getBoredActivity,
        tooltip: 'Search',
        child: Icon(Icons.search),
      ),*/
    );
  }
}

class UpComingEventsDialog extends StatefulWidget {
  @override
  _UpcomingEventsDialogState createState() => new _UpcomingEventsDialogState();
}

class _UpcomingEventsDialogState extends State<UpComingEventsDialog> {
  @override
  Widget build(BuildContext context) {

    final titleTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 14,
      height: 2,
    );

    return Dialog(
        child: Container(
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text('Your upcoming activities:', style: titleTextStyle),
                _buildUpcomingEvents(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                    RaisedButton(
                      onPressed: () {
                        //Update Past and Present events
                        List<String> _tempUpComingList = new List();

                        for(int i =0; i < _upComingboredDataList.length; i++){
                          var activity = _upComingboredDataList[i];
                          if(_selectedDataList[i] == true){
                            _pastBoredDataList.add(activity);

                          } else {
                            _tempUpComingList.add(activity);
                          }
                        }
                        _upComingboredDataList.removeRange(0, _upComingboredDataList.length);
                        _selectedDataList.removeRange(0, _selectedDataList.length);

                        for(int i =0; i < _tempUpComingList.length; i++){
                          var activity = _tempUpComingList[i];
                          _upComingboredDataList.add(activity);
                          _selectedDataList.add(false);
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Complete",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    )
                  ],
                )

              ],
            )));
  }

  Widget _buildUpcomingEvents() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        itemCount: _upComingboredDataList.length,
        itemBuilder: /*1*/ (context, i) {
          return ListTile(
              leading: Checkbox(
                  value: _selectedDataList[i],
                  onChanged: (bool value) {
                    setState(() {
                      _selectedDataList[i] = value;
                    });}
              ),
              title: Text(_upComingboredDataList[i])
          );
        });
  }

}