import 'package:appdevproj/controllers/chapterController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appdevproj/models/chapterModel.dart';

final ChapterProvider = ChangeNotifierProvider((ref) {
  return chapterProvider();
});

class chapterProvider extends ChangeNotifier {
  late ChapterModel _selectedChapter;
  late List<DisplayedQuestionModel> _questions = [];
  late List<DisplayedQuestionModel> _attemptedQuestions = [];
  late List<DisplayedQuestionModel> _notAttemptedQuestions = [];

  int _meterCompleteness = 0;
  int _meterAccuracy = 0;

  int get meterCompleteness {
    return _meterCompleteness;
  }

  void setMeterCompleteness(int num) {
    _meterCompleteness = num;
    notifyListeners();
  }

  int get meterAccuracy {
    return _meterAccuracy;
  }

  void setMeterAccuracy(int num) {
    _meterAccuracy = num;
    notifyListeners();
  }

  void resetMeter() {
    _meterAccuracy = 0;
    _meterCompleteness = 0;
    notifyListeners();
  }

  ChapterModel get selectedChapter {
    return _selectedChapter;
  }

  Future<List<DisplayedQuestionModel>> get questions async {
    return _questions;
  }

  List<DisplayedQuestionModel> get attemptedQuestions {
    return _attemptedQuestions;
  }

  List<DisplayedQuestionModel> get notAttemptedQuestions {
    return _notAttemptedQuestions;
  }

  chapterProvider() {}

  void setSelectedChapter(ChapterModel chapter) {
    _selectedChapter = chapter;
    notifyListeners();
  }

  void setQuestionsList(List<DisplayedQuestionModel> questions) {
    _questions = questions;
    notifyListeners();
  }

  void setAttemptedQuestionsList(List<DisplayedQuestionModel> questions) {
    _attemptedQuestions = questions;
    notifyListeners();
  }

  void setNotattemptedQuestionsList(List<DisplayedQuestionModel> questions) {
    _notAttemptedQuestions = questions;
    notifyListeners();
  }
}
