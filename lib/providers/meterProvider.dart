// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final MeterProvider = ChangeNotifierProvider((ref) {
//   return meterProvider();
// });

// class meterProvider extends ChangeNotifier {
//   int _completeness = 0;
//   int _accuracy = 0;

//   meterProvider() {}

//   int get completeness {
//     return _completeness;
//   }

//   void setCompleteness(int num) {
//     _completeness = num;
//     notifyListeners();
//   }

//   int get accuracy {
//     return _accuracy;
//   }

//   void setAccuracy(int num) {
//     _accuracy = num;
//     notifyListeners();
//   }

//   void reset() {
//     _accuracy = 0;
//     _completeness = 0;
//     notifyListeners();
//   }
// }
