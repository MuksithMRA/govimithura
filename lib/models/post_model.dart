import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:govimithura/constants/post_status.dart';
import 'package:govimithura/constants/post_types.dart';

class PostModel<T> {
  String id;
  String title;
  String content;
  String uid;
  double rating;
  String status;
  String formattedDateTime;
  int rateCount;
  String postType;
  int ref;
  String author;
  List<String> savedBy;
  DateTime? createdAt;
  T? refModel;

  PostModel({
    this.id = '',
    this.title = '',
    this.content = '',
    this.uid = '',
    this.rating = 0.0,
    this.status = PostStatus.pending,
    this.formattedDateTime = '',
    this.rateCount = 0,
    this.postType = PostType.pestControlMethod,
    this.ref = 0,
    this.author = '',
    this.savedBy = const [],
    this.createdAt,
    this.refModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'uid': uid,
      'rating': rating,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'status': status,
      'rateCount': rateCount,
      'postType': postType,
      'savedBy': savedBy,
      'ref': ref,
      'author': author,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      uid: map['uid'] ?? '',
      rating: map['rating'] ?? 0.0,
      status: map['status'] ?? PostStatus.pending,
      rateCount: map['rateCount'] ?? 0,
      postType: map['postType'] ?? PostType.pestControlMethod,
      savedBy: map['savedBy'] != null
          ? List<String>.from(map['savedBy'] as List<dynamic>)
          : [],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      ref: map['ref'] ?? 0,
      author: map['author'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  bool get isSaved => savedBy.contains(FirebaseAuth.instance.currentUser!.uid);
}
