import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inter_rapidisimo_technical_test/core/router/list_routes.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/colors/application_colors.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/app_toolbar.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/brand_text_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/cart_control_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/discount_tag_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/image_product_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/price_with_dicount_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/price_with_out_discount_widget.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/title_card_widget.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/events/product_detail_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/providers/product_detail_provider.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/states/product_detail_state.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailProvider(productId));
    final notifier = ref.read(productDetailProvider(productId).notifier);

    return Scaffold(
      appBar: AppToolbar(
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: ApplicationColors.secondBrandColor,
            ),
            onPressed: () => context.pushNamed(ListRoutes.cart.name),
          ),
        ],
      ),
      body: switch (state) {
        ProductDetailLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        ProductDetailError(:final message) => _ErrorBody(
          message: message,
          onRetry: () => notifier.add(LoadProductDetail(productId)),
        ),
        ProductDetailSuccess() => _SuccessBody(
          state: state,
          onAdd: () => notifier.add(AddToCart(state.product)),
          onRemove: () => notifier.add(RemoveFromCart(state.product)),
        ),
      },
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.state,
    required this.onAdd,
    required this.onRemove,
  });

  final ProductDetailSuccess state;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageProductWidget(
                imageUrl: product.images.first,
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleCardWidget(title: product.title, fontSize: 20),
                const SizedBox(height: 10),
                if (product.discountPercentage.round() > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PriceWithOutDiscountWidget(
                        price: product.price,
                        fontSize: 15,
                      ),
                      const SizedBox(width: 8),
                      DiscountTagWidget(
                        discountPercentage: product.discountPercentage,
                        fontSize: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                PriceWithDicountWidget(
                  discountedPrice: product.discountedPrice,
                  fontSize: 22,
                ),
                const SizedBox(height: 8),
                BrandTextWidget(brand: product.brand, fontSize: 13),
                const SizedBox(height: 20),
                SizedBox(
                  width: screenWidth * 0.75,
                  child: CartControlWidget(
                    quantity: state.cartQuantity,
                    isLoading: state.isCartLoading,
                    onAdd: onAdd,
                    onRemove: onRemove,
                    addLabel: 'Agregar al carrito',
                  ),
                ),
                const SizedBox(height: 8),
                ExpansionTile(
                  initiallyExpanded: true,
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product.description,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
