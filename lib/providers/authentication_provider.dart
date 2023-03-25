import 'package:flutter/material.dart';
import 'package:govimithura/models/auth_model.dart';
import 'package:govimithura/models/user_model.dart';
import 'package:govimithura/services/auth_service.dart';
import 'package:govimithura/services/user_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  AuthService authService = AuthService();
  UserModel userModel = UserModel();
  AuthModel authModel = AuthModel();
  Future<void> login(AuthModel authModel) async {
    authService.login(authModel);
  }

  Future register() async {
    userModel.authModel = authModel;
    await authService.register(userModel.authModel!).then(
          (value) => {
            if (value != null)
              {
                userModel.authModel = value,
                UserService.addUser(userModel),
              }
          },
        );
    notifyListeners();
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
