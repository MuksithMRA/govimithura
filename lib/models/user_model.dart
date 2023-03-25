import 'package:govimithura/models/auth_model.dart';

class UserModel {
  AuthModel? authModel;
  String firstName;
  String lastName;

  UserModel({
    this.authModel,
    this.firstName = '',
    this.lastName = '',
  });

  set setFirstName(String firstName) {
    this.firstName = firstName;
  }

  set setLastName(String lastName) {
    this.lastName = lastName;
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'uid': authModel?.uid ?? '',
      'first_name': firstName,
      'last_name': lastName,
      'email': authModel?.email ?? '',
      'userType': authModel?.userType ?? '',
    };
  }
}