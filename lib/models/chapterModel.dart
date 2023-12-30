class ChapterModel {
  String id;
  String subject;
  String name;

  ChapterModel({
    required this.id,
    required this.subject,
    required this.name,
  });

  factory ChapterModel.fromMap(String id, Map<String, dynamic> json) {
    return ChapterModel(
      id: id,
      subject: json['subject'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'name': name,
    };
  }
}
