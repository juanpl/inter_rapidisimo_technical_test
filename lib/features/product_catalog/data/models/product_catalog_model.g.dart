// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_catalog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductCatalogModelImpl _$$ProductCatalogModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductCatalogModelImpl(
  products: (json['products'] as List<dynamic>)
      .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$$ProductCatalogModelImplToJson(
  _$ProductCatalogModelImpl instance,
) => <String, dynamic>{
  'products': instance.products.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
};
