import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:govimithura/constants/images.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/user_model.dart';

class UserService {
  static final User? authUser = FirebaseAuth.instance.currentUser;
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
        'profilePic': Images.defaultAvatar,
      });
      authUser!.updateDisplayName("${user.firstName} ${user.lastName}");
      authUser!.updateEmail(user.authModel!.email);
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message ?? '';
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?> getCurentUser() async {
    QuerySnapshot<Map<String, dynamic>>? result;
    try {
      result = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message ?? '';
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return result;
  }

  static Future<bool> updateSingleField(String key, String value) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({key: value});

      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message ?? '';
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?> getUserByUid(
      String uid) async {
    QuerySnapshot<Map<String, dynamic>>? result;
    try {
      result = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message ?? '';
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return result;
  }
}
