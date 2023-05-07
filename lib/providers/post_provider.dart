import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:govimithura/models/error_model.dart';
import 'package:govimithura/models/insect_model.dart';
import 'package:govimithura/models/post_model.dart';
import 'package:govimithura/services/insect_service.dart';
import 'package:govimithura/services/post_service.dart';
import 'package:govimithura/utils/utils.dart';

class PostProvider extends ChangeNotifier {
  PostModel postModel = PostModel();
  double givenRating = 0;
  List<PostModel<InsectModel>> posts = [];
  PostModel filterPostModel = PostModel();
  String currentScreen = '';

  Future<void> addPost(BuildContext context) async {
    setPostUid(FirebaseAuth.instance.currentUser!.uid);
    setPostCreatedAt(DateTime.now());
    await PostService.addPost(postModel).then(
      (success) => {
        if (success)
          {
            clearPostModel(),
            Utils.showSnackBar(
                context, 'Post added successfully , waiting for approval'),
            Navigator.pop(context),
          }
        else
          {
            Utils.showSnackBar(context, ErrorModel.errorMessage),
          }
      },
    );
  }

  Future<List<PostModel>> getPostsByUid() async {
    posts = [];
    var response =
        await PostService.getPostsByUid(FirebaseAuth.instance.currentUser!.uid);
    if (response != null) {
      for (var item in response.docs) {
        PostModel<InsectModel> post = PostModel.fromMap(item.data());
        var insectResponse = await InsectService.getInsectById(post.ref);
        if (insectResponse != null) {
          InsectModel insect = InsectModel.fromJson(insectResponse.data()!);
          post.refModel = insect;
        }
        posts.add(post);
      }
    }
    notifyListeners();
    return posts;
  }

  Future<List<PostModel<InsectModel>>> getAllPost() async {
    posts = [];
    var response = await PostService.getAllPosts();

    if (response != null) {
      for (var item in response.docs) {
        PostModel<InsectModel> post =
            PostModel<InsectModel>.fromMap(item.data());
        var insectResponse = await InsectService.getInsectById(post.ref);
        if (insectResponse != null) {
          InsectModel insect = InsectModel.fromJson(insectResponse.data()!);
          post.refModel = insect;
        }
        posts.add(post);
      }
    }
    notifyListeners();
    return posts;
  }

  Future<List<PostModel>> getAllPostByType() async {
    posts = [];
    if (filterPostModel.ref >= 0) {
      var response =
          await PostService.getApprovedPostsByTypeAndRef(filterPostModel);
      if (response != null) {
        for (var item in response.docs) {
          PostModel<InsectModel> post =
              PostModel<InsectModel>.fromMap(item.data());
          posts.add(post);
        }
      }
      notifyListeners();
    }
    posts.sort((a, b) => b.rating.compareTo(a.rating));
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
          postModel.id = postId;
          success = await PostService.updateRating(postModel);
          if (success) {
            await refreshPostList();
          }
        }
      },
    );
    notifyListeners();
    return success;
  }

  Future<bool> savePost(String postId) async {
    bool success = false;
    await PostService.savePost(postId).then(
      (value) async {
        success = value;
        if (success) {
          await refreshPostList();
        }
      },
    );
    notifyListeners();
    return success;
  }

  Future<bool> deletePost(String postId) async {
    bool success = false;
    await PostService.deletePost(postId).then(
      (value) async {
        success = value;
        if (success) {
          await refreshPostList();
        }
      },
    );
    notifyListeners();
    return success;
  }

  Future<bool> unSavePost(String postId) async {
    bool success = false;
    await PostService.unSavePost(postId).then(
      (value) async {
        success = value;
        if (success) {
          await refreshPostList();
        }
      },
    );
    notifyListeners();
    return success;
  }

  Future<List<PostModel<InsectModel>>> getAllSavedPost() async {
    posts = [];
    var response = await PostService.getSavedPosts();
    if (response != null) {
      for (var item in response.docs) {
        PostModel<InsectModel> post = PostModel.fromMap(item.data());
        posts.add(post);
      }
    }
    notifyListeners();
    return posts;
  }

  Future<bool> changePostStatus(PostModel post) async {
    bool success = false;
    await PostService.changePostStatus(post).then(
      (value) async {
        success = value;
      },
    );
    notifyListeners();
    return success;
  }

  Future<void> refreshPostList() async {
    if (currentScreen == 'posts') {
      await getAllPostByType();
    } else if (currentScreen == 'saved_posts') {
      await getAllSavedPost();
    } else {
      await getAllPost();
    }
  }

  void setPostModel(PostModel postModel) {
    this.postModel = postModel;
    notifyListeners();
  }

  void setCurrentScreen(String currentScreen) {
    this.currentScreen = currentScreen;
    notifyListeners();
  }

  void setFilterPostModel(PostModel postModel) {
    filterPostModel = postModel;
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

  void setPostRef(int ref) {
    postModel.ref = ref;
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
