import 'dart:io';

import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  File? _profileImage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  File? get profileImage => _profileImage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }
}