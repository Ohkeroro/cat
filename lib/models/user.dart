class User {
  String name;
  String email;
  String password;

  User({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      email: json["email"],
      password: json["password"],
    );
  }
}
