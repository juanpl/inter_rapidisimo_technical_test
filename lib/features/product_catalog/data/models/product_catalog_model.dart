import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

class ProductCatalogModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductCatalogModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductCatalogModel.fromJson(Map<String, dynamic> json) {
    return ProductCatalogModel(
      products: (json['products'] as List)
          .map(
            (product) => ProductModel.fromJson(product as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() => {
    'products': List<Map<String, dynamic>>.from(
      products.map((x) => x.toJson()),
    ),
  };
}
