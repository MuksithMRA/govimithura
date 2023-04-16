import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:govimithura/constants/post_status.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/post_model.dart';

class PostService {
  static final _posts = FirebaseFirestore.instance.collection('posts');
  static final _postRatings =
      FirebaseFirestore.instance.collection('post_ratings');
  static final _currentUser = FirebaseAuth.instance.currentUser!;

  static Future<bool> addPost(PostModel postModel) async {
    try {
      postModel.author = _currentUser.displayName ?? '';
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

  static Future<QuerySnapshot<Map<String, dynamic>>?> getAllPosts() async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _posts.get();
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

  static Future<QuerySnapshot<Map<String, dynamic>>?> getPostsByUid(
      String uid) async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _posts.where('uid', isEqualTo: uid).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?>
      getApprovedPostsByTypeAndRef(PostModel postModel) async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _posts
          .where('postType', isEqualTo: postModel.postType)
          .where('status', isEqualTo: PostStatus.approved)
          .where('ref', isEqualTo: postModel.ref)
          .get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }

  static Future<bool> addRating(String postId, double ratingValue) async {
    try {
      var rating = await getRatingsByPostId(postId);
      if (rating != null &&
          rating.docs.isNotEmpty &&
          rating.docs
              .any((element) => element.data()['uId'] == _currentUser.uid)) {
        for (var element in rating.docs) {
          if (element.data()['uId'] == _currentUser.uid) {
            _postRatings.doc(element.id).update({
              'rating': ratingValue,
            });
            return true;
          }
        }
      } else {
        await _postRatings.add({
          'postId': postId,
          'uId': _currentUser.uid,
          'rating': ratingValue,
        });
        return true;
      }
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?> getRatingsByPostId(
      String postId) async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot =
          await _postRatings.where('postId', isEqualTo: postId).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }

  static Future<bool> updateRating(PostModel postModel) async {
    try {
      await _posts.doc(postModel.id).update({
        'rating': postModel.rating,
        'rateCount': postModel.rateCount,
      });
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<bool> savePost(String postId) async {
    try {
      await _posts.doc(postId).update({
        'savedBy': FieldValue.arrayUnion([_currentUser.uid]),
      });
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<bool> unSavePost(String postId) async {
    try {
      await _posts.doc(postId).update({
        'savedBy': FieldValue.arrayRemove([_currentUser.uid]),
      });
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?> getSavedPosts() async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot =
          await _posts.where('savedBy', arrayContains: _currentUser.uid).get();
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return querySnapshot;
  }

  static Future<bool> changePostStatus(PostModel post) async {
    try {
      await _posts.doc(post.id).update({
        'status': post.status,
      });
      return true;
    } on FirebaseException catch (e) {
      ErrorModel.errorMessage = e.message!;
    } on Exception catch (e) {
      ErrorModel.errorMessage = e.toString();
    }
    return false;
  }
}
