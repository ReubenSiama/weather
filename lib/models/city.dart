class City {
  final int id;
  final String name;
  final int isDefault;

  const City({
    required this.id,
    required this.name,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_default': isDefault,
    };
  }

  @override
  String toString() {
    return 'City{id: $id, name: $name, isDefault: $isDefault}';
  }
}
