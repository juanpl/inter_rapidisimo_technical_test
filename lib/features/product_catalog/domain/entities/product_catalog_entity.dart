import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_catalog_model.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

class ProductCatalogEntity {
  final List<ProductEntity> products;
  final int total;
  final int skip;
  final int limit;

  ProductCatalogEntity({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  ProductCatalogEntity copyWith({
    List<ProductEntity>? products,
    int? total,
    int? skip,
    int? limit,
  }) => ProductCatalogEntity(
    products: products ?? this.products,
    total: total ?? this.total,
    skip: skip ?? this.skip,
    limit: limit ?? this.limit,
  );

  factory ProductCatalogEntity.fromModel(ProductCatalogModel model) =>
      ProductCatalogEntity(
        products: model.products
            .map((productModel) => ProductEntity.fromModel(productModel))
            .toList(),
        total: model.total,
        skip: model.skip,
        limit: model.limit,
      );
}
