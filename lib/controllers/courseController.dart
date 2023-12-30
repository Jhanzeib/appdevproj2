import 'dart:developer';

import 'package:appdevproj/controllers/chapterController.dart';
import 'package:appdevproj/models/attemptModel.dart';
import 'package:appdevproj/models/chapterModel.dart';
import 'package:appdevproj/models/questionModel.dart';
import 'package:appdevproj/models/subjectModel.dart';
import 'package:appdevproj/providers/courseProvider.dart';
import 'package:appdevproj/providers/subjectProvider.dart';
import 'package:appdevproj/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final CourseController = Provider((ref) => courseController(ref));

class courseController {
  late Ref _ref;
  late final courseProvider;
  late db data;

  courseController(Ref ref) {
    _ref = ref;
    courseProvider = _ref.read(CourseProvider);
    data = _ref.read(DB);
  }

  getSubjects() async {
    courseProvider.setSubjectList(
        await data.getSubjects(courseProvider.selectedCourse.id));
  }

  getStats() async {
    List<QuestionModel> allQuestions = await data.getAllQuestions();
    List<AttemptModel> allAttempts = await data.getAttempts();

    List<SubjectModel> concernedSubs = await courseProvider.subjects;
    Set<String> concernedSubsIds = concernedSubs.map((sub) => sub.id).toSet();
    List<ChapterModel> concernedChaps = [];

    List<ChapterModel> allChapters = await data.getAllChapters();

    for (var chaps in allChapters) {
      if (concernedSubsIds.contains(chaps.subject)) {
        concernedChaps.add(chaps);
      }
    }
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

    log("message");

    if (attemptedQuestions.length > 0) {
      courseProvider.setMeterCompleteness(((attemptedQuestions.length /
                  (attemptedQuestions.length + notAttemptedQuestions.length)) *
              100)
          .round());
      courseProvider
          .setMeterAccuracy(await calculateAccuracy(attemptedQuestions));
    } else {
      courseProvider.setMeterCompleteness(0);
      courseProvider.setMeterAccuracy(0);
    }
  }
}
