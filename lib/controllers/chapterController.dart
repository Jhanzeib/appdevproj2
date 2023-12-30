import 'package:appdevproj/models/attemptModel.dart';
import 'package:appdevproj/models/questionModel.dart';
import 'package:appdevproj/providers/chapterProvider.dart';
import 'package:appdevproj/providers/meterProvider.dart';
import 'package:appdevproj/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChapterController = Provider((ref) => chapterController(ref));

class chapterController {
  late Ref _ref;
  late db data;

  chapterController(Ref ref) {
    _ref = ref;
    data = ref.read(DB);
  }

  Future<void> getQuestions() async {
    final chapProvider = _ref.watch(ChapterProvider);

    List<QuestionModel> allQuestions =
        await data.getQuestions(_ref.watch(ChapterProvider).selectedChapter.id);

    List<AttemptModel> allAttempts = await data.getAttempts();

    allAttempts.sort((a, b) => a.time.compareTo(b.time));

    Set<String> answeredQuestionIds =
        allAttempts.map((attempt) => attempt.question).toSet();

    List<DisplayedQuestionModel> attemptedQuestions = [];
    List<DisplayedQuestionModel> notAttemptedQuestions = [];

    for (var question in allQuestions) {
      if (answeredQuestionIds.contains(question.id)) {
        attemptedQuestions.add(
          DisplayedQuestionModel(
            question: QuestionModel(
              id: question.id,
              answers: question.answers,
              chapter: question.chapter,
              content: question.content,
              explanation: question.explanation,
              correct: question.correct,
            ),
            answer: allAttempts
                .firstWhere((a) => a.question == question.id)
                .answered,
          ),
        );
      } else {
        notAttemptedQuestions.add(
          DisplayedQuestionModel(
            question: QuestionModel(
              id: question.id,
              answers: question.answers,
              chapter: question.chapter,
              content: question.content,
              explanation: question.explanation,
              correct: question.correct,
            ),
            answer: "none",
          ),
        );
      }
    }

    List<String> orderedQuestionIds = answeredQuestionIds.toList();
    Map<String, int> idToIndexMap = {};
    for (int i = 0; i < orderedQuestionIds.length; i++) {
      idToIndexMap[orderedQuestionIds[i]] = i;
    }
    attemptedQuestions.sort((a, b) {
      int indexA = idToIndexMap[a.question.id] ?? -1;
      int indexB = idToIndexMap[b.question.id] ?? -1;
      return indexA.compareTo(indexB);
    });

    if (attemptedQuestions.length > 0) {
      chapProvider.setMeterCompleteness(((attemptedQuestions.length /
                  (attemptedQuestions.length + notAttemptedQuestions.length)) *
              100)
          .round());
      chapProvider
          .setMeterAccuracy(await calculateAccuracy(attemptedQuestions));
    } else {
      chapProvider.setMeterCompleteness(0);
      chapProvider.setMeterAccuracy(0);
    }
    chapProvider.setAttemptedQuestionsList(attemptedQuestions);
    chapProvider.setNotattemptedQuestionsList(notAttemptedQuestions);
    chapProvider.setQuestionsList(attemptedQuestions + notAttemptedQuestions);
  }
}

Future<int> calculateAccuracy(List<DisplayedQuestionModel> list) async {
  int correct = 0;
  int total = 0;
  for (var i = 0; i < list.length; i++) {
    if (list[i].answer == list[i].question.correct) {
      correct++;
    }
    total++;
  }
  return ((correct / total) * 100).round();
}

class DisplayedQuestionModel {
  String answer;
  QuestionModel question;

  DisplayedQuestionModel({
    required this.question,
    required this.answer,
  });
}
