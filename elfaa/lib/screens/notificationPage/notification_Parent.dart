import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification2 {
  final String message;
  final String zone;
  final DateTime time;

  UserNotification2(
      {required this.message, required this.zone, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'zone': this.zone,
      'time': Timestamp.fromDate(this.time),
    };
  }

  factory UserNotification2.fromMap(dynamic map) {
    Timestamp timeStamp = map['time'] ?? Timestamp.now();
    return UserNotification2(
      message: map['message'] as String,
      zone: map['zone'] as String,
      time: timeStamp.toDate(),
    );
  }
}
