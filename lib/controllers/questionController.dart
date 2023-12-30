import 'package:appdevproj/providers/questionProvider.dart';
import 'package:appdevproj/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final QuestionController = Provider((ref) => questionController(ref));

class questionController {
  late Ref _ref;
  late db data;

  questionController(Ref ref) {
    _ref = ref;
    data = _ref.read(DB);
  }

  Future<void> attemptQuestion() async {
    final QProv = _ref.watch(QuestionProvider);
    data.attemptQuestion(
        QProv.selectedQuestion.question.id, QProv.selectedAnswer ?? "");
  }
}
