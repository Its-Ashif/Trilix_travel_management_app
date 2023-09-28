class UserModel {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  int profilePic;
  String uid;
  String createdAt;

  UserModel({
    required this.lastName,
    required this.firstName,
    required this.phoneNumber,
    required this.email,
    required this.profilePic,
    required this.uid,
    required this.createdAt,
  });

  //from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      lastName: map['lastName'] ?? '',
      firstName: map['firstName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "email": email,
      "profilePic": profilePic,
      "uid": uid,
      "createdAt": createdAt,
    };
  }
}
