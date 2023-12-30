import 'package:appdevproj/chapter.dart';
import 'package:appdevproj/course.dart';
import 'package:appdevproj/home.dart';
import 'package:appdevproj/login.dart';
import 'package:appdevproj/profile.dart';
import 'package:appdevproj/question.dart';
import 'package:appdevproj/signup.dart';
import 'package:appdevproj/subject.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      name: 'course',
      path: '/course',
      builder: (context, state) => CourseScreen(),
    ),
    GoRoute(
      name: 'subject',
      path: '/subject',
      builder: (context, state) => SubjectScreen(),
    ),
    GoRoute(
      name: 'chapter',
      path: '/chapter',
      builder: (context, state) => ChapterScreen(),
    ),
    GoRoute(
      name: 'question',
      path: '/question',
      builder: (context, state) => QuestionScreen(),
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
  ],
);
