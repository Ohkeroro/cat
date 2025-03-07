class Cat {
  String name;
  String details;
  String imagePath;
  String userEmail;

  Cat({
    required this.name, 
    required this.details, 
    required this.imagePath,
    this.userEmail = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'details': details,
        'imagePath': imagePath,
        'userEmail': userEmail,
      };

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'],
      details: json['details'],
      imagePath: json['imagePath'],
      userEmail: json['userEmail'] ?? '',
    );
  }
}