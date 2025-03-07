import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocaleProvider with ChangeNotifier {

  static LocaleProvider watch(context) => Provider.of<LocaleProvider>(context);
  static LocaleProvider read(context) => Provider.of<LocaleProvider>(context, listen: false);

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }
}