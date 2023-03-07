class User {
  int? userId;
  String? username;

  User({this.userId, this.username});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}
