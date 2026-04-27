class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double raiting;
  final double discountPercentage;
  final String brand;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.raiting,
    required this.discountPercentage,
    required this.brand,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      raiting: (json['rating'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      brand: json['brand'] as String? ?? '',
      images: List<String>.from(json['images'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'raiting': raiting,
    'discountPercentage': discountPercentage,
    'brand': brand,
    'images': images,
  };
}
