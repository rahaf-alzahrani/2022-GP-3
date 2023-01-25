import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String? parentID;
  String? childrenId;
  String? childName;
  String? imageUrl;
  String? date;
  DateTime time;

  Note({
    this.id,
    this.parentID,
    this.childrenId,
    this.childName,
    this.imageUrl,
    this.date,
    required this.time,
  });
  factory Note.fromMap(map) {
    Timestamp timeStamp = map['time'] ?? Timestamp.now();
    return Note(
      id: map["id"],
      parentID: map['parentId'],
      childrenId: map['childrenId'],
      childName: map['childName'],
      imageUrl: map['imageUrl'],
      date: map['date'],
      time: timeStamp.toDate(),
    );
  }
  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'parentId': parentID,
      'id': id,
      'childrenId': childrenId,
      'imageUrl': imageUrl,
      "childName": childName,
      'date': date,
      'time': Timestamp.fromDate(time),
    };
  }

  // String? notID;
  // String? zone_name;
  // DateTime? time;
  // GeoPoint? location;
  // note();
  // Map<String, dynamic> toJson() =>
  //     {'time': time, 'location': location, 'zone_name': zone_name};

  // note.fromSnapshot(snapshot)
  //     : notID = snapshot.id,
  //       zone_name = snapshot.data()['zone_name'],
  //       time = snapshot.data()['time'].toDate(),
  //       location = snapshot.data()['location'];
}
