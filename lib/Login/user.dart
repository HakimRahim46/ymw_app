class User {
  int? id;
  String? name;
  String? email;
  String? password;

  User({this.id, this.name, this.email, this.password});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    password = map['password'];
  }}