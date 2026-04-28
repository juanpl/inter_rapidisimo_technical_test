import 'dart:convert';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

class CartProductModel {
  final int productId;
  final ProductModel productModel;
  final int quantity;

  CartProductModel({
    required this.productModel,
    required this.quantity,
    required this.productId,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    final productJson =
        jsonDecode(json['product_json'] as String) as Map<String, dynamic>;
    return CartProductModel(
      productId: ProductModel.fromJson(productJson).id,
      productModel: ProductModel.fromJson(productJson),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_json': jsonEncode(productModel.toJson()),
    'quantity': quantity,
  };

  factory CartProductModel.fromEntity(CartProductEntity entity) =>
      CartProductModel(
        productModel: ProductModel.fromEntity(entity.product),
        quantity: entity.quantity,
        productId: entity.product.id,
      );
}
