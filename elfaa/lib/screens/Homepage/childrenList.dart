class childrenList {
  String? childImagePath;
  String? childName;
  String? childID;
  DateTime? childbirthday;
  int? childHeight;
  String? childGender;
  List? nots;
  bool? status;
  childrenList();
  Map<String, dynamic> toJson() => {
        'image': childImagePath,
        'name': childName,
        'birthday': childbirthday,
        'height': childHeight,
        'gender': childGender,
        'notifications': nots,
      };

  childrenList.fromSnapshot(snapshot)
      : childHeight = snapshot.data()['height'],
        childName = snapshot.data()['name'],
        childID = snapshot.id,
        status = snapshot.data()['status'],
        childImagePath = snapshot.data()['image'],
        childbirthday = snapshot.data()['birthday'].toDate(),
        childGender = snapshot.data()['gender'],
        nots = snapshot.data()['notifications'];
}

