import 'package:appdevproj/models/attemptModel.dart';
import 'package:appdevproj/models/chapterModel.dart';
import 'package:appdevproj/models/courseModel.dart';
import 'package:appdevproj/models/coursesSubscribedModel.dart';
import 'package:appdevproj/models/questionModel.dart';
import 'package:appdevproj/models/subjectModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final DB = Provider((ref) => db());

class db {
  late FirebaseAuth _auth = FirebaseAuth.instance;
  late FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email address is already in use.';
      } else {
        return 'An error occurred, please try later.';
      }
    }
  }

  Future<String> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return 'Invalid email or password.';
      } else {
        return 'An error occurred, please try later.';
      }
    }
  }

  userName() {
    return _auth.currentUser?.displayName ?? '';
  }

  user() {
    return _auth.currentUser ?? null;
  }

  updateUserName(String name) {
    _auth.currentUser?.updateDisplayName(name);
  }

  userEmail() {
    return _auth.currentUser?.email ?? '';
  }

  updateUserEmail(String name) {
    _auth.currentUser?.updateEmail(name);
  }

  updateUserPassword(String pass) {
    _auth.currentUser?.updatePassword(pass);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> attemptQuestion(String question, String answer) async {
    _firestore.collection('attempts').add({
      'time': DateTime.now()
          .toString()
          .replaceAll(RegExp(r'[\s-:]'), '')
          .substring(0, 17)
          .toString(),
      'user': _auth.currentUser?.uid,
      'question': question,
      'answered': answer,
    });
  }

  Future<List<QuestionModel>> getQuestions(String id) async {
    CollectionReference questionCollection = _firestore.collection('questions');
    QuerySnapshot questionQuerySnapshot =
        await questionCollection.where('chapter', isEqualTo: id).get();
    return questionQuerySnapshot.docs.map((doc) {
      return QuestionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<QuestionModel>> getAllQuestions() async {
    CollectionReference questionCollection = _firestore.collection('questions');
    QuerySnapshot questionQuerySnapshot = await questionCollection.get();
    return questionQuerySnapshot.docs.map((doc) {
      return QuestionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<AttemptModel>> getAttempts() async {
    CollectionReference attemptCollection = _firestore.collection('attempts');
    QuerySnapshot attemptQuerySnapshot = await attemptCollection
        .where('user', isEqualTo: _auth.currentUser!.uid)
        .get();
    return attemptQuerySnapshot.docs.map((doc) {
      return AttemptModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<SubjectModel>> getSubjects(String id) async {
    CollectionReference subjectCollection = _firestore.collection('subjects');
    QuerySnapshot subjectQuerySnapshot =
        await subjectCollection.where('course', isEqualTo: id).get();

    return subjectQuerySnapshot.docs.map((doc) {
      return SubjectModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<ChapterModel>> getChapters(String id) async {
    CollectionReference questionCollection = _firestore.collection('chapters');
    QuerySnapshot questionQuerySnapshot =
        await questionCollection.where('subject', isEqualTo: id).get();
    return questionQuerySnapshot.docs.map((doc) {
      return ChapterModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<ChapterModel>> getAllChapters() async {
    CollectionReference questionCollection = _firestore.collection('chapters');
    QuerySnapshot questionQuerySnapshot = await questionCollection.get();
    return questionQuerySnapshot.docs.map((doc) {
      return ChapterModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<CourseModel>> getAllCourses() async {
    CollectionReference questionCollection = _firestore.collection('courses');
    QuerySnapshot questionQuerySnapshot = await questionCollection.get();
    return questionQuerySnapshot.docs.map((doc) {
      return CourseModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<CoursesSubscribedModel> getSubscribedCourses() async {
    CollectionReference subscribedCoursesCollection =
        _firestore.collection('coursesSubscribed');
    QuerySnapshot querySnapshot = await subscribedCoursesCollection
        .where('user', isEqualTo: _auth.currentUser!.uid.toString())
        .get();
    return querySnapshot.docs.map((doc) {
      return CoursesSubscribedModel.fromMap(
          doc.id, doc.data() as Map<String, dynamic>);
    }).toList()[0];
  }
}
