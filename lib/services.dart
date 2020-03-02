import 'package:flutter_app2/boreddata.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

final String url = 'http://www.boredapi.com/api/activity/';

Future<BoredData> getRandomActivity() async{
  final response = await http.get('$url');
  return boredDataFromJson(response.body);
}
Future<BoredData> getRandomActivityFor(String type, double price,
    double accessibility, int participants) async{
  String url ='https://www.boredapi.com/api/activity?type='+type+
      '&participants='+participants.toString()+'&price='+price.toString()+'&accessibility='+accessibility.toString();
  final response = await http.get(url);
  return boredDataFromJson(response.body);
}