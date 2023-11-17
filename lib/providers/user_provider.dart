import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_class.dart';
import 'package:flutter_instagram_clone/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDeatils();
    _user = user;
    notifyListeners();
  }
}
