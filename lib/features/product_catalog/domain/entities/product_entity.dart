import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

class ProductEntity {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double raiting;
  final double discountPercentage;
  final String brand;
  final List<String> images;
  final double discountedPrice;

  ProductEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.raiting,
    required this.discountPercentage,
    required this.brand,
    required this.images,
    this.discountedPrice = 0,
  });

  ProductEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? raiting,
    double? discountPercentage,
    String? brand,
    List<String>? images,
    double? discountedPrice,
  }) => ProductEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    price: price ?? this.price,
    raiting: raiting ?? this.raiting,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    brand: brand ?? this.brand,
    images: images ?? this.images,
    discountedPrice: discountedPrice ?? this.discountedPrice,
  );

  factory ProductEntity.fromModel(ProductModel model) => ProductEntity(
    id: model.id,
    title: model.title,
    category: model.category,
    description: model.description,
    price: model.price,
    raiting: model.raiting,
    discountPercentage: model.discountPercentage,
    brand: model.brand,
    images: model.images,
  );
}
