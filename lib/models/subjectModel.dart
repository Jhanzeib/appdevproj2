class SubjectModel {
  String id;
  String course;
  String img;
  String name;

  SubjectModel({
    required this.id,
    required this.course,
    required this.img,
    required this.name,
  });

  factory SubjectModel.fromMap(String id, Map<String, dynamic> json) {
    return SubjectModel(
      id: id,
      course: json['course'] as String,
      img: json['img'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'img': img,
      'name': name,
    };
  }
}
