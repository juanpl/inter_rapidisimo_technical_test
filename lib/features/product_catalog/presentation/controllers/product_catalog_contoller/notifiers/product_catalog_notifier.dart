import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/get_product_catalog_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/search_products_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/events/product_catalog_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/product_catalog_contoller/states/product_catalog_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _limit = 10;
const _cacheKey = 'product_catalog_cache';

class ProductCatalogNotifier extends Notifier<ProductCatalogState> {
  int _currentOffset = 0;

  @override
  ProductCatalogState build() {
    Future.microtask(() => add(const LoadProductCatalog()));
    return const ProductCatalogLoading();
  }

  Future<void> add(ProductCatalogEvent event) async {
    switch (event) {
      case LoadProductCatalog():
        await _onLoad();
      case LoadMoreProducts():
        await _onLoadMore();
      case RefreshProductCatalog():
        await _onRefresh();
      case AddToCart(:final product):
        await _onAddToCart(product);
      case RemoveFromCart(:final product):
        await _onRemoveFromCart(product);
      case ReloadCart():
        await _onReloadCart();
      case SearchProducts(:final query):
        await _onSearchProducts(query);
    }
  }

  Future<void> _onLoad() async {
    state = const ProductCatalogLoading();
    _currentOffset = 0;
    try {
      final catalog = await GetIt.I<GetProductCatalogUseCase>()(_limit, 0);
      final cartProducts = await _fetchCartProducts();
      _currentOffset = catalog.products.length;
      _saveCache(catalog.products);
      state = ProductCatalogSuccess(
        products: catalog.products,
        total: catalog.total,
        hasReachedEnd: catalog.products.length >= catalog.total,
        cartProducts: cartProducts,
      );
    } on CustomException catch (e) {
      final cached = await _loadCache();
      final cartProducts = await _fetchCartProducts();
      if (cached != null && cached.isNotEmpty) {
        state = ProductCatalogSuccess(
          products: cached,
          total: cached.length,
          hasReachedEnd: true,
          cartProducts: cartProducts,
        );
      } else {
        state = ProductCatalogError(e.message);
      }
    }
  }

  Future<void> _onLoadMore() async {
    final current = state;
    if (current is! ProductCatalogSuccess) return;
    if (current.isLoadingMore || current.hasReachedEnd) return;

    state = current.copyWith(isLoadingMore: true);
    try {
      final catalog = await GetIt.I<GetProductCatalogUseCase>()(
        _limit,
        _currentOffset,
      );
      final allProducts = [...current.products, ...catalog.products];
      _currentOffset = allProducts.length;
      state = ProductCatalogSuccess(
        products: allProducts,
        total: catalog.total,
        hasReachedEnd: allProducts.length >= catalog.total,
        cartProducts: current.cartProducts,
      );
    } on CustomException {
      state = current.copyWith(isLoadingMore: false);
    }
  }

  Future<void> _onRefresh() async {
    _currentOffset = 0;
    await _onLoad();
  }

  Future<void> _onSearchProducts(String query) async {
    if (query.isEmpty) {
      await _onRefresh();
      return;
    }
    state = const ProductCatalogLoading();
    try {
      final catalog = await GetIt.I<SearchProductsUseCase>()(query);
      final cartProducts = await _fetchCartProducts();
      state = ProductCatalogSuccess(
        products: catalog.products,
        total: catalog.total,
        hasReachedEnd: true,
        isSearchMode: true,
        cartProducts: cartProducts,
      );
    } on CustomException catch (e) {
      state = ProductCatalogError(e.message);
    }
  }

  Future<void> _onReloadCart() async {
    final current = state;
    if (current is! ProductCatalogSuccess) return;
    final cartProducts = await _fetchCartProducts();
    state = current.copyWith(cartProducts: cartProducts);
  }

  Future<List<CartProductEntity>> _fetchCartProducts() async {
    try {
      return await GetIt.I<GetCartUseCase>()();
    } catch (_) {
      return [];
    }
  }

  Future<void> _onAddToCart(ProductEntity product) async {
    final current = state;
    if (current is! ProductCatalogSuccess) return;

    state = current.copyWith(
      loadingProductIds: {...current.loadingProductIds, product.id},
    );

    try {
      await GetIt.I<AddProductToCartUseCase>()(product, 1);
      final updated = state as ProductCatalogSuccess;
      final index = updated.cartProducts.indexWhere(
        (e) => e.product.id == product.id,
      );
      final updatedCart = List<CartProductEntity>.from(updated.cartProducts);
      if (index >= 0) {
        final existing = updatedCart[index];
        updatedCart[index] = existing.copyWith(quantity: existing.quantity + 1);
      } else {
        updatedCart.add(CartProductEntity(product: product, quantity: 1));
      }
      state = updated.copyWith(
        cartProducts: updatedCart,
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    } on CustomException {
      final updated = state as ProductCatalogSuccess;
      state = updated.copyWith(
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    }
  }

  Future<void> _onRemoveFromCart(ProductEntity product) async {
    final current = state;
    if (current is! ProductCatalogSuccess) return;

    state = current.copyWith(
      loadingProductIds: {...current.loadingProductIds, product.id},
    );

    try {
      await GetIt.I<RemoveProductFromCartUseCase>()(product, 1);
      final updated = state as ProductCatalogSuccess;
      final index = updated.cartProducts.indexWhere(
        (e) => e.product.id == product.id,
      );
      final updatedCart = List<CartProductEntity>.from(updated.cartProducts);
      if (index >= 0) {
        final existing = updatedCart[index];
        if (existing.quantity <= 1) {
          updatedCart.removeAt(index);
        } else {
          updatedCart[index] = existing.copyWith(
            quantity: existing.quantity - 1,
          );
        }
      }
      state = updated.copyWith(
        cartProducts: updatedCart,
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    } on CustomException {
      final updated = state as ProductCatalogSuccess;
      state = updated.copyWith(
        loadingProductIds: {...updated.loadingProductIds}..remove(product.id),
      );
    }
  }

  Future<void> _saveCache(List<ProductEntity> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = products
          .map(
            (p) => {
              'id': p.id,
              'title': p.title,
              'description': p.description,
              'category': p.category,
              'price': p.price,
              'rating': p.rating,
              'discountPercentage': p.discountPercentage,
              'brand': p.brand,
              'images': p.images,
              'discountedPrice': p.discountedPrice,
            },
          )
          .toList();
      await prefs.setString(_cacheKey, jsonEncode(list));
    } catch (_) {}
  }

  Future<List<ProductEntity>?> _loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_cacheKey);
      if (json == null) return null;
      final list = jsonDecode(json) as List;
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        return ProductEntity(
          id: map['id'] as int,
          title: map['title'] as String,
          description: map['description'] as String,
          category: map['category'] as String,
          price: (map['price'] as num).toDouble(),
          rating: (map['rating'] as num).toDouble(),
          discountPercentage: (map['discountPercentage'] as num).toDouble(),
          brand: map['brand'] as String,
          images: List<String>.from(map['images'] as List),
          discountedPrice: (map['discountedPrice'] as num?)?.toDouble() ?? 0,
        );
      }).toList();
    } catch (_) {
      return null;
    }
  }
}
