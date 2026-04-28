import 'package:flutter/material.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/brand_text_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/cart_control_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/discount_tag_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/image_product_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/price_with_dicount_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/price_with_out_discount_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/title_card_widget.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.item,
    required this.isLoading,
    required this.onAdd,
    required this.onRemove,
  });

  final CartProductEntity item;
  final bool isLoading;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageProductWidget(
                imageUrl: product.images.first,
                height: 90,
                width: 90,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleCardWidget(title: product.title, fontSize: 13),
                  const SizedBox(height: 4),
                  if (product.discountPercentage.round() > 0) ...[
                    Row(
                      children: [
                        PriceWithOutDiscountWidget(
                          price: product.price,
                          fontSize: 11,
                        ),
                        const SizedBox(width: 6),
                        DiscountTagWidget(
                          discountPercentage: product.discountPercentage,
                          fontSize: 10,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                  PriceWithDicountWidget(
                    discountedPrice: product.discountedPrice,
                    fontSize: 13,
                  ),
                  const SizedBox(height: 2),
                  BrandTextWidget(brand: product.brand, fontSize: 11),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CartControlWidget(
              quantity: item.quantity,
              isLoading: isLoading,
              onAdd: onAdd,
              onRemove: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
