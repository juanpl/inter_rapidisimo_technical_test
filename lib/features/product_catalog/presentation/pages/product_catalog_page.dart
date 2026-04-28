import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inter_rapidisimo_technical_test/core/router/list_routes.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/events/product_catalog_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/providers/product_catalog_provider.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/states/product_catalog_state.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/widgets/product_card_shimmer_widget.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/widgets/product_card_widget.dart';

const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 0.46,
);

class ProductCatalogPage extends ConsumerStatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  ConsumerState<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends ConsumerState<ProductCatalogPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      ref.read(productCatalogProvider.notifier).add(const LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productCatalogProvider);

    return Scaffold(
      body: SafeArea(
        child: switch (state) {
          ProductCatalogInitial() ||
          ProductCatalogLoading() => const _ShimmerGrid(),
          ProductCatalogSuccess() => _SuccessBody(
            state: state,
            scrollController: _scrollController,
            onRefresh: () => ref
                .read(productCatalogProvider.notifier)
                .add(const RefreshProductCatalog()),
            onEvent: ref.read(productCatalogProvider.notifier).add,
            onProductTap: (productId) async {
              await context.pushNamed(
                ListRoutes.productDetail.name,
                pathParameters: {'id': productId.toString()},
              );
              ref
                  .read(productCatalogProvider.notifier)
                  .add(const ReloadCart());
            },
          ),
          ProductCatalogError() => _ErrorBody(
            message: state.message,
            onRetry: () => ref
                .read(productCatalogProvider.notifier)
                .add(const LoadProductCatalog()),
          ),
        },
      ),
    );
  }
}

class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _gridDelegate,
        itemCount: 6,
        itemBuilder: (context, _) => const ProductCardShimmerWidget(),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.state,
    required this.scrollController,
    required this.onRefresh,
    required this.onEvent,
    required this.onProductTap,
  });

  final ProductCatalogSuccess state;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final void Function(ProductCatalogEvent) onEvent;
  final void Function(int productId) onProductTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = state.products[index];
                return ProductCardWidget(
                  imageUrl: product.images.first,
                  title: product.title,
                  rating: product.rating,
                  price: product.price,
                  discountedPrice: product.discountedPrice,
                  discountPercentage: product.discountPercentage,
                  brand: product.brand,
                  cartQuantity: state.cartQuantity(product.id),
                  isCartLoading: state.isProductLoading(product.id),
                  onAddToCart: () => onEvent(AddToCart(product)),
                  onRemoveFromCart: () => onEvent(RemoveFromCart(product)),
                  onTap: () => onProductTap(product.id),
                );
              }, childCount: state.products.length),
              gridDelegate: _gridDelegate,
            ),
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (state.hasReachedEnd)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('No hay más productos')),
                ),
              ),
          ],
        ),
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
          ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
