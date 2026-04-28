import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/events/cart_event.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/states/cart_state.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    Future.microtask(() => add(const LoadCart()));
    return const CartLoading();
  }

  Future<void> add(CartEvent event) async {
    switch (event) {
      case LoadCart():
        await _onLoad();
      case AddToCart(:final product):
        await _onAddToCart(product);
      case RemoveFromCart(:final product):
        await _onRemoveFromCart(product);
    }
  }

  Future<void> _onLoad() async {
    state = const CartLoading();
    try {
      final items = await GetIt.I<GetCartUseCase>()();
      state = CartSuccess(items: items);
    } on CustomException catch (e) {
      state = CartError(e.message);
    }
  }

  Future<void> _onAddToCart(ProductEntity product) async {
    final current = state;
    if (current is! CartSuccess) return;

    state = current.copyWith(
      loadingProductIds: {...current.loadingProductIds, product.id},
    );

    try {
      await GetIt.I<AddProductToCartUseCase>()(product, 1);
      final updated = state as CartSuccess;
      final index = updated.items.indexWhere((e) => e.product.id == product.id);
      final updatedItems = List<CartProductEntity>.from(updated.items);
      if (index >= 0) {
        final existing = updatedItems[index];
        updatedItems[index] = existing.copyWith(quantity: existing.quantity + 1);
      } else {
        updatedItems.add(CartProductEntity(product: product, quantity: 1));
      }
      state = updated.copyWith(
        items: updatedItems,
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    } on CustomException {
      final updated = state as CartSuccess;
      state = updated.copyWith(
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    }
  }

  Future<void> _onRemoveFromCart(ProductEntity product) async {
    final current = state;
    if (current is! CartSuccess) return;

    state = current.copyWith(
      loadingProductIds: {...current.loadingProductIds, product.id},
    );

    try {
      await GetIt.I<RemoveProductFromCartUseCase>()(product, 1);
      final updated = state as CartSuccess;
      final index = updated.items.indexWhere((e) => e.product.id == product.id);
      final updatedItems = List<CartProductEntity>.from(updated.items);
      if (index >= 0) {
        final existing = updatedItems[index];
        if (existing.quantity <= 1) {
          updatedItems.removeAt(index);
        } else {
          updatedItems[index] = existing.copyWith(
            quantity: existing.quantity - 1,
          );
        }
      }
      state = updated.copyWith(
        items: updatedItems,
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    } on CustomException {
      final updated = state as CartSuccess;
      state = updated.copyWith(
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    }
  }
}
