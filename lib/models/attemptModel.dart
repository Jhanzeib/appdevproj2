class AttemptModel {
  String id;
  String user;
  String time;
  String question;
  String answered;

  AttemptModel({
    required this.id,
    required this.user,
    required this.time,
    required this.question,
    required this.answered,
  });

  factory AttemptModel.fromMap(String id, Map<String, dynamic> json) {
    return AttemptModel(
      id: id,
      user: json['user'] as String,
      question: json['question'] as String,
      time: json['time'] as String,
      answered: json['answered'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'question': question,
      'time': time,
      'answered': answered,
    };
  }
}
