import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:govimithura/constants/post_status.dart';
import 'package:govimithura/constants/post_types.dart';

class PostModel {
  String id;
  String title;
  String content;
  String uid;
  double rating;
  String status;
  String formattedDateTime;
  int rateCount;
  String postType;
  List<String> savedBy;
  DateTime? createdAt;

  PostModel({
    this.id = '',
    this.title = '',
    this.content = '',
    this.uid = '',
    this.createdAt,
    this.rating = 0.0,
    this.status = PostStatus.pending,
    this.rateCount = 0,
    this.formattedDateTime = '',
    this.savedBy = const [],
    this.postType = PostType.pestControlMethod,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  bool get isSaved => savedBy.contains(FirebaseAuth.instance.currentUser!.uid);
}
