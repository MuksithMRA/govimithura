import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  AuthService authService = AuthService();
  UserModel userModel = UserModel();
  AuthModel authModel = AuthModel();

  Future<bool> login() async {
    bool success = await authService.login(authModel).then((value) => value);
    if (success) {
      await getCurentUserModel();
    }
    return success;
  }

  Future<bool> register() async {
    userModel.authModel = authModel;
    return await authService.register(userModel.authModel!).then(
      (value) {
        if (value != null) {
          userModel.authModel = value;
          UserService.addUser(userModel);
          return true;
        } else {
          return false;
        }
      },
    );
  }

  Future<void> signOut() async {
    await authService.signOut();
  }

  bool isLoggedIn() {
    return authService.isLoggedIn();
  }

  Future<UserModel?> getCurentUserModel() async {
    if (authService.isLoggedIn()) {
      return await UserService.getCurentUser().then((value) {
        if (value != null) {
          Map<String, dynamic> user = value.docs.first.data();
          authModel.email = user['email'];
          authModel.userType = user['user_type'];
          authModel.uid = user['uid'];
          userModel.authModel = authModel;
          userModel.firstName = user['first_name'];
          userModel.lastName = user['last_name'];
          notifyListeners();
          return userModel;
        }
        return null;
      });
    }
    return null;
  }

  Future<bool> updateSingleField(String key, String value) async {
    return await UserService.updateSingleField(key, value)
        .then((success) async {
      if (success) {
        await getCurentUserModel();
        getCurrentUser()!
            .updateDisplayName("${userModel.firstName} ${userModel.lastName}");
        return true;
      } else {
        return false;
      }
    });
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  setFirstName(String firstName) {
    userModel.setFirstName = firstName;
    notifyListeners();
  }

  setLastName(String lastName) {
    userModel.setLastName = lastName;
    notifyListeners();
  }

  setPassWord(String password) {
    authModel.password = password;
    notifyListeners();
  }

  setConfirmPassword(String confirmPassword) {
    authModel.confirmPassword = confirmPassword;
    notifyListeners();
  }

  setEmail(String email) {
    authModel.email = email;
    notifyListeners();
  }
}
