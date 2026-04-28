import 'dart:convert';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

class CartProductModel {
  final ProductModel productModel;
  final int quantity;

  CartProductModel({required this.productModel, required this.quantity});

  factory CartProductModel.fromDBMap(Map<String, dynamic> dbMap) {
    final productJson =
        jsonDecode(dbMap['product_json'] as String) as Map<String, dynamic>;
    return CartProductModel(
      productModel: ProductModel.fromJson(productJson),
      quantity: dbMap['quantity'] as int,
    );
  }
}
