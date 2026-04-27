import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/notifiers/product_catalog_notifier.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/presentation/controllers/states/product_catalog_state.dart';

final productCatalogProvider =
    NotifierProvider<ProductCatalogNotifier, ProductCatalogState>(
  ProductCatalogNotifier.new,
);
