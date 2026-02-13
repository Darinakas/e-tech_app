class Product {
  final int? id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;

  Product({this.id, required this.name, required this.category, required this.description, required this.price, required this.imageUrl,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'] ?? 'https://example.com/default.jpg',
    );
  }
}