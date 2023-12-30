class CoursesSubscribedModel {
  String id;
  String user;
  List<String> courses;

  CoursesSubscribedModel({
    required this.id,
    required this.user,
    required this.courses,
  });

  factory CoursesSubscribedModel.fromMap(String id, Map<String, dynamic> json) {
    return CoursesSubscribedModel(
      id: id,
      user: json['user'] as String,
      courses: (json['courses'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'courses': courses,
    };
  }
}
