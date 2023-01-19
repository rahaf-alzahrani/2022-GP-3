class SecurityList {
  String? secName;
  String? phoneNo;
  String? secID;
  String? password;
  String? email;
  SecurityList();
  Map<String, dynamic> toJson() => {
        'name': secName,
        'phoneNo': phoneNo,
        'email' : email,
    'password' : password
      };

  SecurityList.fromSnapshot(snapshot)
      : secName = snapshot.data()['name'],
        secID = snapshot.id,
        phoneNo= snapshot.data()['phoneNo'],
        email = snapshot.data()['email'],
        password = snapshot.data()['passWord'];
}
