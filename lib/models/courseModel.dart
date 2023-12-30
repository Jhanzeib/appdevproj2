class CourseModel {
  String id;
  String img;
  String name;

  CourseModel({
    required this.id,
    required this.img,
    required this.name,
  });

  factory CourseModel.fromMap(String id, Map<String, dynamic> json) {
    return CourseModel(
      id: id,
      img: json['img'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img': img,
      'name': name,
    };
  }
}
