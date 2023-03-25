class AuthModel {
  String email;
  String password;
  String confirmPassword;
  String uid;
  String userType;
  AuthModel({
    this.email = '',
    this.password = '',
    this.uid = '',
    this.userType = 'user',
    this.confirmPassword = '',
  });

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setUserType(String userType) {
    this.userType = userType;
  }

  void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
  }
}

enum UserType {
  admin,
  user,
}
