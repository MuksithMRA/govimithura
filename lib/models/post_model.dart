import 'dart:convert';

class PostModel {
  String id;
  String title;
  String content;
  String uid;
  double rating;
  String status;
  String formattedDateTime;
  int rateCount = 0;
  DateTime? createdAt;

  PostModel({
    this.id = '',
    this.title = '',
    this.content = '',
    this.uid = '',
    this.createdAt,
    this.rating = 0.0,
    this.status = 'Pending',
    this.rateCount = 0,
    this.formattedDateTime = '',
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
      'rate_count': rateCount
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      uid: map['uid'] ?? '',
      rating: map['rating'] ?? 0.0,
      status: map['status'] ?? 'Pending',
      rateCount: map['rate_count'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
