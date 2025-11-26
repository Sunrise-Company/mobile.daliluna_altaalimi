class ClassModel {
  final int id;
  final String name;
  final String image;

  ClassModel({required this.id, required this.name, required this.image});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}