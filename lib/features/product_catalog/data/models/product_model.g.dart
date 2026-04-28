// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: const _NumToDouble().fromJson(json['price'] as num),
      rating: const _NumToDouble().fromJson(json['rating'] as num),
      discountPercentage: const _NumToDouble().fromJson(
        json['discountPercentage'] as num,
      ),
      brand: json['brand'] as String? ?? '',
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'price': const _NumToDouble().toJson(instance.price),
      'rating': const _NumToDouble().toJson(instance.rating),
      'discountPercentage': const _NumToDouble().toJson(
        instance.discountPercentage,
      ),
      'brand': instance.brand,
      'images': instance.images,
    };
