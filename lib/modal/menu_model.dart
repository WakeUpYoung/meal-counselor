class MenuModel {
  int? id;
  String name;
  double weight;
  int schemeId;

  MenuModel({
    required this.name,
    required this.weight,
    required this.schemeId,
    this.id,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'schemeId': schemeId,
    };
  }

  @override
  String toString() {
    return 'Menu{id: $id, name: $name, weight: $weight, scheme: $schemeId}';
  }
}