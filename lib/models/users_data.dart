import 'package:cloud_firestore/cloud_firestore.dart';

class UsersData {
  String password;
  String email;
  String username;
  String title;
  String profileImage;
  String uid;
  List followers;
  List following;
  UsersData({
    required this.email,
    required this.username,
    required this.title,
    required this.password,
    required this.profileImage,
    required this.uid,
    required this.following,
    required this.followers,
  });

// To convert the UserData(Data type) to   Map<String, Object>
  Map<String, dynamic> convert2Map() {
    return {
      "password": password,
      "email": email,
      "title": title,
      "username": username,
      "profileImage": profileImage,
      "uid": uid,
      "followers": [],
      "following": [],
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UsersData(
      password: snapshot["password"],
      email: snapshot["email"],
      title: snapshot["title"],
      username: snapshot["username"],
      profileImage: snapshot["profileImage"],
      uid: snapshot["uid"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
