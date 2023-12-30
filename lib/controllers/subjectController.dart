import 'package:appdevproj/controllers/chapterController.dart';
import 'package:appdevproj/models/attemptModel.dart';
import 'package:appdevproj/models/chapterModel.dart';
import 'package:appdevproj/models/questionModel.dart';
import 'package:appdevproj/providers/subjectProvider.dart';
import 'package:appdevproj/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final SubjectController = Provider((ref) => subjectController(ref));

class subjectController {
  late Ref _ref;
  late db data;

  subjectController(Ref ref) {
    _ref = ref;
    data = _ref.read(DB);
  }

  getChapters() async {
    _ref.watch(SubjectProvider).setChapterList(
        await data.getChapters(_ref.watch(SubjectProvider).selectedSubject.id));
  }

  getStats() async {
    final subProvider = _ref.watch(SubjectProvider);

    List<QuestionModel> allQuestions = await data.getAllQuestions();
    List<AttemptModel> allAttempts = await data.getAttempts();

    List<ChapterModel> concernedChaps = await subProvider.chapters;
    Set<String> concernedChapsIds = concernedChaps.map((sub) => sub.id).toSet();
    List<QuestionModel> concernedQuestions = [];

    for (var question in allQuestions) {
      if (concernedChapsIds.contains(question.chapter)) {
        concernedQuestions.add(question);
      }
    }

    List<DisplayedQuestionModel> attemptedQuestions = [];
    List<DisplayedQuestionModel> notAttemptedQuestions = [];

    Set<String> answeredQuestionIds =
        allAttempts.map((attempt) => attempt.question).toSet();

    for (var question in concernedQuestions) {
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

    if (attemptedQuestions.length > 0) {
      subProvider.setMeterCompleteness(((attemptedQuestions.length /
                  (attemptedQuestions.length + notAttemptedQuestions.length)) *
              100)
          .round());
      subProvider.setMeterAccuracy(await calculateAccuracy(attemptedQuestions));
    } else {
      subProvider.setMeterCompleteness(0);
      subProvider.setMeterAccuracy(0);
    }
  }
}
