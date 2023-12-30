import 'package:appdevproj/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'course.dart';
import 'subject.dart';
import 'chapter.dart';
import 'question.dart';
import 'profile.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDbGTpRso26kC0NoeBNumN8nc6F1YcXYVE",
        appId: "1:775396234685:web:2607bc17744c1eaa1a6ed4",
        messagingSenderId: "775396234685",
        projectId: "my-mock-exam",
        storageBucket: "my-mock-exam.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
      ),
      title: 'My Mock Exam',
    );
  }
}
