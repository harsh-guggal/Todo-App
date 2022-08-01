class UserModel {
  String? uid;
  String? username;
  String? email;
  String? password;

  UserModel({this.uid, this.username, this.email, this.password});

// receiving data from server/database
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }

// sending data to server/database
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
