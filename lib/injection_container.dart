import 'package:get_it/get_it.dart';

import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/core/database/sqlite_db.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/product_catalog_injection_container.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/product_detail_injection_container.dart';

import 'features/cart/cart_injection_container.dart';

final getIt = GetIt.instance;

void initInjectionContainer() {
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerLazySingleton<SqliteDB>(() => SqliteDB());

  productCatalogInjectionContainer(getIt);
  cartInjectionContainer(getIt);
  productDetailInjectionContainer(getIt);
}
