import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/post_model.dart';
import 'package:govimithura/services/post_service.dart';
import 'package:govimithura/utils/utils.dart';

class PostProvider extends ChangeNotifier {
  PostModel postModel = PostModel();
  double givenRating = 0;

  Future<void> addPost(BuildContext context) async {
    setPostUid(FirebaseAuth.instance.currentUser!.uid);
    setPostCreatedAt(DateTime.now());
    await PostService.addPost(postModel).then((success) => {
          if (success)
            {
              clearPostModel(),
              Navigator.pop(context),
            }
          else
            {
              Utils.showSnackBar(context, ErrorModel.errorMessage),
            }
        });
  }

  Future<List<PostModel>> getPostsByUid() async {
    List<PostModel> posts = [];
    var response =
        await PostService.getPostsByUid(FirebaseAuth.instance.currentUser!.uid);
    if (response != null) {
      for (var item in response.docs) {
        PostModel post = PostModel.fromMap(item.data());
        posts.add(post);
      }
    }
    notifyListeners();
    return posts;
  }

  Future<List<PostModel>> getAllPost() async {
    List<PostModel> posts = [];
    var response = await PostService.getAllPosts();
    if (response != null) {
      for (var item in response.docs) {
        PostModel post = PostModel.fromMap(item.data());
        posts.add(post);
      }
    }
    notifyListeners();
    return posts;
  }

  Future<List<PostModel>> getAllPostByType(String postType) async {
    List<PostModel> posts = [];
    var response = await PostService.getPostsByType(postType);
    if (response != null) {
      for (var item in response.docs) {
        PostModel post = PostModel.fromMap(item.data());
        posts.add(post);
      }
    }
    notifyListeners();
    return posts;
  }

  Future<PostModel> getPostsById(String id) async {
    PostModel post = PostModel();
    var response = await PostService.getPostById(id);
    if (response != null) {
      post = PostModel.fromMap(response.data()!);
    }
    notifyListeners();
    return post;
  }

  Future<PostModel> getAverageRating(String id) async {
    PostModel ratingPost = PostModel();
    var response = await PostService.getRatingsByPostId(id);
    if (response != null && response.docs.isNotEmpty) {
      double totalRating = 0;
      for (var item in response.docs) {
        if (item.data()['rating'] != null) {
          totalRating += item.data()['rating'];
        }
      }
      ratingPost.rateCount = response.docs.length;
      ratingPost.rating = totalRating / ratingPost.rateCount;
    }
    notifyListeners();
    return ratingPost;
  }

  Future<bool> addRating(String postId) async {
    bool success = false;
    await PostService.addRating(postId, givenRating).then(
      (value) async {
        success = value;
        if (success) {
          PostModel postModel = await getAverageRating(postId);
          success = await PostService.updateRating(postId, postModel);
        }
      },
    );
    notifyListeners();
    return success;
  }

  void setPostModel(PostModel postModel) {
    this.postModel = postModel;
    notifyListeners();
  }

  void setPostTitle(String title) {
    postModel.title = title;
    notifyListeners();
  }

  void setPostContent(String content) {
    postModel.content = content;
    notifyListeners();
  }

  void setPostUid(String uid) {
    postModel.uid = uid;
    notifyListeners();
  }

  void setPostCreatedAt(DateTime createdAt) {
    postModel.createdAt = createdAt;
    notifyListeners();
  }

  void clearPostModel() {
    postModel = PostModel();
    notifyListeners();
  }

  void setGivenRating(double rating) {
    givenRating = rating;
    notifyListeners();
  }
}
