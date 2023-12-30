import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appdevproj/models/subjectModel.dart';
import 'package:appdevproj/models/courseModel.dart';

final CourseProvider = ChangeNotifierProvider((ref) {
  return courseProvider();
});

class courseProvider extends ChangeNotifier {
  late CourseModel _selectedCourse;
  late List<SubjectModel> _subjects = [];
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

  CourseModel get selectedCourse {
    return _selectedCourse;
  }

  Future<List<SubjectModel>> get subjects async {
    return _subjects;
  }

  courseProvider() {}

  void setSelectedCourse(CourseModel course) {
    _selectedCourse = course;
    notifyListeners();
  }

  void setSubjectList(List<SubjectModel> subjects) {
    _subjects = subjects;
    notifyListeners();
  }
}
