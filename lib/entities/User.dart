class User {
  int? userId;
  int? id;
  final String username;
  String? email;
  String? password;
  String? imgUrl;

  User(
      {this.userId,
      this.id,
      required this.username,
      this.email,
      this.password,
      this.imgUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        userId: json['userId'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        imgUrl: json['imgUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': username,
      'email': email,
      'password': password,
      'imgUrl': imgUrl
    };
  }
}
