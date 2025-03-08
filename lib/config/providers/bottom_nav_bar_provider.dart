import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBarProvider with ChangeNotifier {

  static BottomNavBarProvider watch(context) => Provider.of<BottomNavBarProvider>(context);
  static BottomNavBarProvider read(context) => Provider.of<BottomNavBarProvider>(context, listen: false);

  
  int _selectedIndex = 0; // Track the current selected tab index

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}