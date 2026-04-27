import 'package:flutter/material.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/image_product_widget.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/widgets/price_with_dicount_widget.dart';

import 'brand_text_widget.dart';
import 'buy_button_widget.dart';
import 'discount_tag_widget.dart';
import 'price_with_out_discount_widget.dart';
import 'rating_bar_indicator_card_widget.dart';
import 'title_card_widget.dart';

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
  });

  final String imageUrl;
  final String title;
  final double rating;
  final double price;
  final double discountedPrice;
  final double discountPercentage;
  final String brand;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(height: 8),
            Row(
              children: [
                PriceWithOutDiscountWidget(price: price),
                const SizedBox(width: 8),
                DiscountTagWidget(discountPercentage: discountPercentage),
              ],
            ),
            const SizedBox(height: 4),
            PriceWithDicountWidget(discountedPrice: discountedPrice),
            const SizedBox(height: 6),
            BrandTextWidget(brand: brand),
            const Spacer(),
            BuyButtonWidget(),
          ],
        ),
      ),
    );
  }
}
