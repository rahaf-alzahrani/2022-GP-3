import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String? id;
  String? parentID;
  String? childrenId;
  String? childName;
  String? imageUrl;
  String? status;
  String? date;
  DateTime time;
  String? lat;
  String? long;
  String? finderID;
  Report(
      {this.id,
      this.parentID,
      this.childrenId,
      this.status,
      this.childName,
      this.imageUrl,
      this.date,
      required this.time,
      this.lat,
      this.long,
      this.finderID});

  //receive data to server

  factory Report.fromMap(map) {
    Timestamp timeStamp = map['time'] ?? Timestamp.now();
    return Report(
        id: map["id"],
        parentID: map['parentId'],
        childrenId: map['childrenId'],
        childName: map['childName'],
        imageUrl: map['imageUrl'],
        status: map["status"],
        date: map['date'],
        time: timeStamp.toDate() ,
        lat: map['lat'],
        long: map['long'],
        finderID: map['finderID']);
  }
  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'parentId': parentID,
      'id': id,
      'childrenId': childrenId,
      'imageUrl': imageUrl,
      "childName": childName,
      'status': status,
      'date': date,
      'time': Timestamp.fromDate(time),
      'lat': lat,
      'long': long,
      'finderID': finderID
    };
  }
}
