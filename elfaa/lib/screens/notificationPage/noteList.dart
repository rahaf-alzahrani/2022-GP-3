import 'package:cloud_firestore/cloud_firestore.dart';

class noteList {
  String? notID;
  String? zone_name;
  DateTime? time;
  GeoPoint? location;
  noteList();
  Map<String, dynamic> toJson() =>
      {'time': time, 'location': location, 'zone_name': zone_name};

  noteList.fromSnapshot(snapshot)
      : notID = snapshot.id,
        zone_name = snapshot.data()['zone_name'],
        time = snapshot.data()['time'].toDate(),
        location = snapshot.data()['location'];
}
