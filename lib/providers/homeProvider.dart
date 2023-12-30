import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appdevproj/controllers/homeController.dart';

final HomeProvider = ChangeNotifierProvider<homeProvider>((ref) {
  return homeProvider();
});

class homeProvider extends ChangeNotifier {
  late List<DisplayedCourseListModel> _displayedCourseList = [];

  Future<List<DisplayedCourseListModel>> get displayedCourseList async {
    return _displayedCourseList;
  }

  homeProvider() {}

  void setDisplayedCourseList(List<DisplayedCourseListModel> list) {
    _displayedCourseList = list;
    notifyListeners();
  }
}
