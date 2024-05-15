class User {
  final int? id;
  final String username;
  final String password;
  final String email;

  User({this.id, required this.username, required this.password, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'username': username,
      'password': password,
      'email': email,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
    );
  }
}