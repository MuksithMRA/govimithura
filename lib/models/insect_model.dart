class InsectModel {
  int id;
  String name;
  String description;

  InsectModel({
    this.id = 0,
    this.name = '',
    this.description = '',
  });

  InsectModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'] ?? '',
        description = json['description'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
