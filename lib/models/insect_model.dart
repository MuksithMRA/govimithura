class InsectModel {
  int id;
  String name;
  String description;
  String image;

  InsectModel({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.image = '',
  });

  InsectModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'] ?? '',
        description = json['description'] ?? '',
        image = json['image'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
      };
}
