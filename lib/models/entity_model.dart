// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EntityModel {
  int id;
  String description;

  EntityModel({
    this.id = 0,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
    };
  }

  factory EntityModel.fromMap(Map<String, dynamic> map) {
    return EntityModel(
      id: map['id'] as int,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EntityModel.fromJson(String source) =>
      EntityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
