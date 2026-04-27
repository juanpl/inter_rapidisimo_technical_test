import 'package:get_it/get_it.dart';

import 'package:inter_rapidisimo_technical_test/core/api/api_client.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/product_catalog_injection_container.dart';

final getIt = GetIt.instance;

void initInjectionContainer() {
  getIt.registerSingleton<ApiClient>(ApiClient());

  productCatalogInjectionContainer(getIt);
}
