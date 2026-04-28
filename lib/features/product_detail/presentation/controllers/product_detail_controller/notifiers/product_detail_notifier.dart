import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/use_cases/get_product_by_id_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/events/product_detail_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/states/product_detail_state.dart';

class ProductDetailNotifier
    extends FamilyNotifier<ProductDetailState, int> {
  @override
  ProductDetailState build(int arg) {
    Future.microtask(() => add(LoadProductDetail(arg)));
    return const ProductDetailLoading();
  }

  Future<void> add(ProductDetailEvent event) async {
    switch (event) {
      case LoadProductDetail(:final productId):
        await _onLoad(productId);
      case AddToCart(:final product):
        await _onAddToCart(product);
      case RemoveFromCart(:final product):
        await _onRemoveFromCart(product);
    }
  }

  Future<void> _onLoad(int productId) async {
    state = const ProductDetailLoading();
    try {
      final product = await GetIt.I<GetProductByIdUseCase>()(productId);
      final cartQuantity = await _fetchCartQuantity(product.id);
      state = ProductDetailSuccess(product: product, cartQuantity: cartQuantity);
    } on CustomException catch (e) {
      state = ProductDetailError(e.message);
    }
  }

  Future<void> _onAddToCart(ProductEntity product) async {
    final current = state;
    if (current is! ProductDetailSuccess) return;

    state = current.copyWith(isCartLoading: true);
    try {
      await GetIt.I<AddProductToCartUseCase>()(product, 1);
      final updated = state as ProductDetailSuccess;
      state = updated.copyWith(
        isCartLoading: false,
        cartQuantity: updated.cartQuantity + 1,
      );
    } on CustomException {
      final updated = state as ProductDetailSuccess;
      state = updated.copyWith(isCartLoading: false);
    }
  }

  Future<void> _onRemoveFromCart(ProductEntity product) async {
    final current = state;
    if (current is! ProductDetailSuccess) return;

    state = current.copyWith(isCartLoading: true);
    try {
      await GetIt.I<RemoveProductFromCartUseCase>()(product, 1);
      final updated = state as ProductDetailSuccess;
      state = updated.copyWith(
        isCartLoading: false,
        cartQuantity: (updated.cartQuantity - 1).clamp(0, double.maxFinite.toInt()),
      );
    } on CustomException {
      final updated = state as ProductDetailSuccess;
      state = updated.copyWith(isCartLoading: false);
    }
  }

  Future<int> _fetchCartQuantity(int productId) async {
    try {
      final items = await GetIt.I<GetCartUseCase>()();
      return items
              .where((e) => e.product.id == productId)
              .firstOrNull
              ?.quantity ??
          0;
    } catch (_) {
      return 0;
    }
  }
}
