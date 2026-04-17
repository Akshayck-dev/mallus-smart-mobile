class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    final String name = json['name'] ?? 'Unknown';
    // Generate a stable integer ID from the name if the actual ID is missing
    final int generatedId = json['id'] ?? name.hashCode.abs();
    
    return Category(
      id: generatedId,
      name: name,
    );
  }
}
