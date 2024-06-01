

import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/firebase_services/authentication.dart';
import 'package:instgram_responsive_app/models/users_data.dart';

class UserProvider with ChangeNotifier {
  UsersData? _userData;
  UsersData? get getUser => _userData;
  
  refreshUser() async {
    UsersData userData = await AuthenticationMethod().getUserDetails();
    _userData = userData;
    notifyListeners();
  }
 }


