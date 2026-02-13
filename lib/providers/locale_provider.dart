import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Язык по умолчанию — английский

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners(); // Уведомить слушателей (перерисовать UI)
    }
  }

  void clearLocale() {
    _locale = const Locale('en'); // можно сбрасывать на дефолтный
    notifyListeners();
  }
}
