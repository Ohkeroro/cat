class Cat {
  String name;
  String details;
  String imagePath;

  Cat({required this.name, required this.details, required this.imagePath});

  Map<String, dynamic> toJson() => {
        'name': name,
        'details': details,
        'imagePath': imagePath,
      };

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'],
      details: json['details'],
      imagePath: json['imagePath'],
    );
  }
}
