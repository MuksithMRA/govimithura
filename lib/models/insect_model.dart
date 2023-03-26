class InsectModel {
  String id;
  String name;
  String description;

  InsectModel(
      {required this.id, required this.name, required this.description});

  InsectModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
