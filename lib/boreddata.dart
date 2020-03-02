// To parse this JSON data, do
//
//     final boredData = boredDataFromJson(jsonString);

import 'dart:convert';

BoredData boredDataFromJson(String str) => BoredData.fromJson(json.decode(str));

String boredDataToJson(BoredData data) => json.encode(data.toJson());

class BoredData {
  String activity;
  double accessibility;
  String type;
  int participants;
  double price;
  String link;
  String key;
  String error;

  BoredData({
    this.activity,
    this.accessibility,
    this.type,
    this.participants,
    this.price,
    this.link,
    this.key,
    this.error,
  });

  factory BoredData.fromJson(Map<String, dynamic> json) => BoredData(
    activity: json["activity"],
    accessibility: json["accessibility"] == null ? 0 : json["accessibility"] .toDouble(),
    type: json["type"],
    participants: json["participants"],
    price: json["price"] == null ? 0 :json["price"].toDouble(),
    link: json["link"],
    key: json["key"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "activity": activity,
    "accessibility": accessibility,
    "type": type,
    "participants": participants,
    "price": price,
    "link": link,
    "key": key,
    "error": error,
  };
}
