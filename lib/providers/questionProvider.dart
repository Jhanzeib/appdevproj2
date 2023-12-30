import 'package:appdevproj/controllers/chapterController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final QuestionProvider = ChangeNotifierProvider((ref) {
  return questionProvider();
});

class questionProvider extends ChangeNotifier {
  late DisplayedQuestionModel _selectedQuestion;
  String? _selectedAnswer;
  late isWhat _iswhat;
  late int _index;

  DisplayedQuestionModel get selectedQuestion {
    return _selectedQuestion;
  }

  String? get selectedAnswer => _selectedAnswer;

  isWhat get iswhat {
    return _iswhat;
  }

  int get index {
    return _index;
  }

  void setSelectedQuestion(DisplayedQuestionModel question) {
    _selectedQuestion = question;
    notifyListeners();
  }

  void resetSelectedAnswer() {
    _selectedAnswer = null;
    notifyListeners();
  }

  void setSelectedAnswer(String answer) {
    _selectedAnswer = answer;
    notifyListeners();
  }

  void setIsWhat(isWhat answer) {
    _iswhat = answer;
    notifyListeners();
  }

  void setIndex(int num) {
    _index = num;
    notifyListeners();
  }
}

enum isWhat {
  question,
  answer,
  review,
}
