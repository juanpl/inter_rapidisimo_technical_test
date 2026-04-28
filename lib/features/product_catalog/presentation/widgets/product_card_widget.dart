import 'package:flutter/material.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/brand_text_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/cart_control_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/discount_tag_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/image_product_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/price_with_dicount_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/price_with_out_discount_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/rating_bar_indicator_card_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/title_card_widget.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.brand,
    required this.cartQuantity,
    required this.isCartLoading,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final double rating;
  final double price;
  final double discountedPrice;
  final double discountPercentage;
  final String brand;
  final int cartQuantity;
  final bool isCartLoading;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageProductWidget(imageUrl: imageUrl),
              ),
              const SizedBox(height: 8),
              TitleCardWidget(title: title),
              const SizedBox(height: 4),
              RatingBarIndicatorCardWidget(rating: rating),
              if (discountPercentage.round() > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    PriceWithOutDiscountWidget(price: price),
                    const SizedBox(width: 8),
                    DiscountTagWidget(discountPercentage: discountPercentage),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              PriceWithDicountWidget(discountedPrice: discountedPrice),
              const SizedBox(height: 6),
              BrandTextWidget(brand: brand),
              const Spacer(),
              CartControlWidget(
                quantity: cartQuantity,
                isLoading: isCartLoading,
                onAdd: onAddToCart,
                onRemove: onRemoveFromCart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
