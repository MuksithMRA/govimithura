import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/post_model.dart';

class PostService {
  static final _posts = FirebaseFirestore.instance.collection('posts');
  static Future<bool> addPost(PostModel postModel) async {
    try {
      await _posts.add(postModel.toMap()).then((value) {
        postModel.id = value.id;
        _posts.doc(value.id).update(postModel.toMap());
      });
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>? getAllPosts() {
    Future<QuerySnapshot<Map<String, dynamic>>>? querySnapshot;
    try {
      querySnapshot = _posts.get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>?> getPostById(
      String id) async {
    DocumentSnapshot<Map<String, dynamic>>? documentSnapshot;
    try {
      documentSnapshot = await _posts.doc(id).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return documentSnapshot;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>? getPostsByUid(
      String uid) {
    Future<QuerySnapshot<Map<String, dynamic>>>? querySnapshot;
    try {
      querySnapshot = _posts.where('uid', isEqualTo: uid).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }
}
