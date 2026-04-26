import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/datasources/product_catalog_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/repository_impl/product_catalog_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/repositories/product_catalog_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/domain/use_cases/get_product_catalog_use_case.dart';

final getIt = GetIt.instance;

void productCatalogInjectionContainer(GetIt getIt) {
  if (!getIt.isRegistered<ProductCatalogDatasource>()) {
    getIt.registerSingleton<ProductCatalogDatasource>(
      ProductCatalogDatasource(),
    );
  }

  if (!getIt.isRegistered<ProductCatalogRepository>()) {
    getIt.registerSingleton<ProductCatalogRepository>(
      ProductCatalogRepositoryImpl(),
    );
  }

  if (!getIt.isRegistered<GetProductCatalogUseCase>()) {
    getIt.registerSingleton<GetProductCatalogUseCase>(
      GetProductCatalogUseCase(),
    );
  }
}

void unregisterProductCatalogInjectionContainer() {
  GetIt.I.unregister<GetProductCatalogUseCase>();
  GetIt.I.unregister<ProductCatalogRepository>();
  GetIt.I.unregister<GetProductCatalogUseCase>();
}
