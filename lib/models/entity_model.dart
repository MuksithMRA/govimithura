// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EntityModel {
  int id;
  String description;
  String name;
  String image;

  EntityModel({
    this.id = 0,
    this.description = '',
    this.name = '',
    this.image = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'name': name,
      'image': image,
    };
  }

  factory EntityModel.fromMap(Map<String, dynamic> map) {
    return EntityModel(
      id: map['id'] ?? 0,
      description: map['description'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EntityModel.fromJson(String source) =>
      EntityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
