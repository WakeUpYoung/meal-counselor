class SchemeModel {
  int? id;
  String name;

  SchemeModel({
    required this.name,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Menu{id: $id, name: $name}';
  }

}