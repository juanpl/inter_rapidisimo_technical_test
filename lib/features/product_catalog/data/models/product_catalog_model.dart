import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

part 'product_catalog_model.freezed.dart';
part 'product_catalog_model.g.dart';

@freezed
class ProductCatalogModel with _$ProductCatalogModel {
  const factory ProductCatalogModel({
    required List<ProductModel> products,
    required int total,
    required int skip,
    required int limit,
  }) = _ProductCatalogModel;

  factory ProductCatalogModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCatalogModelFromJson(json);
}
