class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      inStock: json['inStock'] as bool,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'tags': tags,
    };
  }
}
