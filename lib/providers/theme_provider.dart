import 'package:flutter/material.dart';

/// Gère la préférence de thème (clair/sombre) de l'application.
/// Fonctionnalité optionnelle du cahier des charges.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get estSombre => _themeMode == ThemeMode.dark;

  void basculer(bool sombre) {
    _themeMode = sombre ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
