import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/user_model.dart';

class UserService {
  static Future<bool> addUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.authModel!.uid)
          .set({
        'uid': user.authModel?.uid ?? '',
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.authModel?.email ?? '',
        'user_type': user.authModel?.userType ?? '',
      });
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message ?? '';
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }
}
