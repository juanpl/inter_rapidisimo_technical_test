import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

class _NumToDouble implements JsonConverter<double, num> {
  const _NumToDouble();

  @override
  double fromJson(num value) => value.toDouble();

  @override
  num toJson(double value) => value;
}

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required int id,
    required String title,
    required String description,
    required String category,
    @_NumToDouble() required double price,
    @_NumToDouble() required double rating,
    @_NumToDouble() required double discountPercentage,
    @Default('') String brand,
    required List<String> images,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

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
}
