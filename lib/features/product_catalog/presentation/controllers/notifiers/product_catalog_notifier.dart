import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/entities/product_entity.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/get_product_catalog_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/events/product_catalog_event.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/states/product_catalog_state.dart';
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
    }
  }

  Future<void> _onLoad() async {
    state = const ProductCatalogLoading();
    _currentOffset = 0;
    try {
      final catalog = await GetIt.I<GetProductCatalogUseCase>()(_limit, 0);
      _currentOffset = catalog.products.length;
      _saveCache(catalog.products);
      state = ProductCatalogSuccess(
        products: catalog.products,
        total: catalog.total,
        hasReachedEnd: catalog.products.length >= catalog.total,
      );
    } on CustomException catch (e) {
      final cached = await _loadCache();
      if (cached != null && cached.isNotEmpty) {
        state = ProductCatalogSuccess(
          products: cached,
          total: cached.length,
          hasReachedEnd: true,
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
      );
    } on CustomException {
      state = current.copyWith(isLoadingMore: false);
    }
  }

  Future<void> _onRefresh() async {
    _currentOffset = 0;
    await _onLoad();
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
              'raiting': p.raiting,
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
          raiting: (map['raiting'] as num).toDouble(),
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
