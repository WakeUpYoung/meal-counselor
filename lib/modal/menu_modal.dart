class MenuModal {
  int? id;
  String name;
  double weight;

  MenuModal({
    required this.name,
    required this.weight,
    this.id,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'Menu{id: $id, name: $name, weight: $weight}';
  }
}