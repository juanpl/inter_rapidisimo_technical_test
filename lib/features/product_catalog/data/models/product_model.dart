import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final double discountPercentage;
  final String brand;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
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
      rating: (json['rating'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      brand: json['brand'] as String? ?? '',
      images: List<String>.from(json['images'] as List),
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    category: entity.category,
    price: entity.price,
    rating: entity.rating,
    discountPercentage: entity.discountPercentage,
    brand: entity.brand,
    images: entity.images,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'rating': rating,
    'discountPercentage': discountPercentage,
    'brand': brand,
    'images': images,
  };
}
