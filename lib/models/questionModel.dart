class QuestionModel {
  String id;
  Map<String, String> answers;
  String chapter;
  String content;
  String explanation;
  String correct;

  QuestionModel({
    required this.id,
    required this.answers,
    required this.chapter,
    required this.content,
    required this.correct,
    required this.explanation,
  });

  factory QuestionModel.fromMap(String id, Map<String, dynamic> json) {
    return QuestionModel(
      id: id,
      answers: (json['answers'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as String)),
      chapter: json['chapter'] as String,
      content: json['content'] as String,
      explanation: json['explanation'] as String,
      correct: json['correct'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answers': answers,
      'chapter': chapter,
      'content': content,
      'explanation': explanation,
      'correct': correct,
    };
  }
}
