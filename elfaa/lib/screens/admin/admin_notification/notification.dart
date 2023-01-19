import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification{
  final String message;
  final String newStatus;
  final DateTime time;


  UserNotification({required this.message, required this.newStatus, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'newStatus': this.newStatus,
      'time': Timestamp.fromDate(this.time),
    };
  }

  factory UserNotification.fromMap(dynamic map) {
    Timestamp timeStamp = map['time'] ?? Timestamp.now();
    return UserNotification(
      message: map['message'] as String,
      newStatus: map['newStatus'] as String,
      time: timeStamp.toDate() ,
    );
  }
}