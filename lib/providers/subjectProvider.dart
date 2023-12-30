import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appdevproj/models/chapterModel.dart';
import 'package:appdevproj/models/subjectModel.dart';

final SubjectProvider = ChangeNotifierProvider((ref) {
  return subjectProvider();
});

class subjectProvider extends ChangeNotifier {
  late SubjectModel _selectedSubject;
  late List<ChapterModel> _chapters = [];

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

  SubjectModel get selectedSubject {
    return _selectedSubject;
  }

  Future<List<ChapterModel>> get chapters async {
    return _chapters;
  }

  subjectProvider() {}

  void setSelectedSubject(SubjectModel subject) {
    _selectedSubject = subject;
    notifyListeners();
  }

  void setChapterList(List<ChapterModel> chapters) {
    _chapters = chapters;
    notifyListeners();
  }
}
