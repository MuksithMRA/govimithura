// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:govimithura/models/auth_model.dart';

class UserModel {
  AuthModel? authModel;
  String firstName;
  String lastName;
  String profilePic;

  UserModel({
    this.authModel,
    this.firstName = '',
    this.lastName = '',
    this.profilePic = '',
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
      'profilePic': profilePic,
    };
  }
}
