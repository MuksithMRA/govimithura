import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:govimithura/models/error_model.dart';

class StorageService {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final User? _user = FirebaseAuth.instance.currentUser;

  static Future<String?> uploadImage(File image) async {
    try {
      final ref = _firebaseStorage.ref().child('profileImages/${_user?.uid}');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      ErrorModel.errorMessage = e.toString();
      return null;
    }
  }
}
