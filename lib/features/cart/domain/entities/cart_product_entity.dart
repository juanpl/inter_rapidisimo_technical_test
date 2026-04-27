import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

class CartProductEntity {
  final ProductEntity product;
  final int quantity;

  CartProductEntity({
    required this.product,
    required this.quantity,
  });

  CartProductEntity copyWith({
    ProductEntity? product,
    int? quantity,
  }) => CartProductEntity(
    product: product ?? this.product,
    quantity: quantity ?? this.quantity,
  );
}
