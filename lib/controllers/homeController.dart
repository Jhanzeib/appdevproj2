import 'package:appdevproj/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdevproj/models/courseModel.dart';
import 'package:appdevproj/providers/homeProvider.dart';
import 'package:appdevproj/models/coursesSubscribedModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final HomeController = Provider((ref) => homeController(ref));

class homeController {
  late Ref _ref;
  late db data;
  late FirebaseFirestore _firestore;

  homeController(Ref ref) {
    _ref = ref;
    data = _ref.read(DB);
    _firestore = FirebaseFirestore.instance;
  }

  getUserCourses() async {
    List<CourseModel> allCourses;
    List<DisplayedCourseListModel> userCourses;
    try {
      allCourses = await data.getAllCourses();
      CoursesSubscribedModel? subscribedCourses =
          await data.getSubscribedCourses();

      if (subscribedCourses != null) {
        Set<String> subscribedCourseIds = subscribedCourses.courses.toSet();

        userCourses = allCourses.map((course) {
          bool isSubscribed = subscribedCourseIds.contains(course.id);
          return DisplayedCourseListModel(
            id: course.id,
            img: course.img,
            name: course.name,
            subscribed: isSubscribed,
          );
        }).toList();
      } else {
        userCourses = [];
      }

      _ref.watch(HomeProvider).setDisplayedCourseList(userCourses);
    } catch (e) {
      _ref.watch(HomeProvider).setDisplayedCourseList([]);
    }
  }

  Future<void> subscribe(String id) async {
    try {
      CoursesSubscribedModel? subscribedCourses =
          await data.getSubscribedCourses();

      if (subscribedCourses != null) {
        if (!subscribedCourses.courses.contains(id)) {
          subscribedCourses.courses.add(id);
          await _firestore
              .collection('coursesSubscribed')
              .doc(subscribedCourses.id)
              .update({"courses": subscribedCourses.courses}).then(
                  (value) => getUserCourses());
        }
      }
    } catch (e) {
      getUserCourses();
    }
  }

  Future<void> unsubscribe(String id) async {
    try {
      CoursesSubscribedModel? subscribedCourses =
          await data.getSubscribedCourses();

      if (subscribedCourses != null) {
        if (subscribedCourses.courses.contains(id)) {
          subscribedCourses.courses.remove(id);
          await _firestore
              .collection('coursesSubscribed')
              .doc(subscribedCourses.id)
              .update({"courses": subscribedCourses.courses}).then(
                  (value) => getUserCourses());
        }
      }
    } catch (e) {
      getUserCourses();
    }
  }
}

class DisplayedCourseListModel extends CourseModel {
  bool subscribed;

  DisplayedCourseListModel({
    required String id,
    required String img,
    required String name,
    required this.subscribed,
  }) : super(id: id, img: img, name: name);
}
