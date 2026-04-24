import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/get_product_catalog_use_case.dart';

final getIt = GetIt.instance;

void productCatalogInjectionContainer(GetIt getIt) {
  if (!getIt.isRegistered<GetProductCatalogUseCase>()) {
    getIt.registerSingleton<GetProductCatalogUseCase>(
      GetProductCatalogUseCase(),
    );
  }
}

void unregisterProductCatalogInjectionContainer() {
  GetIt.I.unregister<GetProductCatalogUseCase>();
}
