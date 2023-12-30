import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProfileProvider = ChangeNotifierProvider((ref) {
  return profileProvider();
});

class profileProvider extends ChangeNotifier {
  bool _nameEdit = false;
  bool _emailEdit = false;

  bool get nameEdit {
    return _nameEdit;
  }

  bool get emailEdit {
    return _emailEdit;
  }

  profileProvider() {}

  void setNameEdit(bool b) {
    _nameEdit = b;
    notifyListeners();
  }

  void setEmailEdit(bool b) {
    _emailEdit = b;
    notifyListeners();
  }
}
