import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ThemeProvider = ChangeNotifierProvider((ref) {
  return themeProvider();
});

class themeProvider extends ChangeNotifier {
  late Color _white;
  late Color _black;
  late Color _peach;
  late Color _fawn;
  late Color _yellow;
  late Color _neutral;
  late Color _blue;
  late Color _grey;
  late Color _err;
  late Color _info;

  late bool _isDarkTheme;

  Color get white => _white;
  Color get black => _black;
  Color get peach => _peach;
  Color get fawn => _fawn;
  Color get yellow => _yellow;
  Color get neutral => _neutral;
  Color get blue => _blue;
  Color get grey => _grey;
  Color get err => _err;
  Color get info => _info;

  themeProvider() {
    _initTheme();
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    int hexValue = int.parse(hexColor, radix: 16);
    return Color(hexValue | 0xFF000000);
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _updateColors();
    notifyListeners();
  }

  void _initTheme() {
    _isDarkTheme = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .platformBrightness ==
        Brightness.dark;
    _updateColors();
    notifyListeners();
  }

  void _updateColors() {
    if (!_isDarkTheme) {
      _white = hexToColor("#FFFFFF");
      _black = hexToColor("#000000");
      _peach = hexToColor("#F07E63");
      _fawn = hexToColor("#F0EDE8");
      _yellow = hexToColor("#FAB677");
      _neutral = hexToColor("#757C86");
      _blue = hexToColor("#ACBEEE");
      _grey = hexToColor("#636363");
      _err = hexToColor("#ed4337");
      _info = hexToColor("#1976D2");
    } else {
      _white = hexToColor("#000000");
      _black = hexToColor("#FFFFFF");
      _peach = hexToColor("#F07E63");
      _fawn = hexToColor("#000000");
      _yellow = hexToColor("#FAB677");
      _neutral = hexToColor("#757C86");
      _blue = hexToColor("#ACBEEE");
      _grey = hexToColor("#636363");
      _err = hexToColor("#ed4337");
      _info = hexToColor("#1976D2");
    }
  }
}
