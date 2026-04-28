import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/data/datasources/product_detail_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/data/repository_impl/product_detail_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/repository/product_detail_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/domain/use_cases/get_product_by_id_use_case.dart';

void productDetailInjectionContainer(GetIt getIt) {
  if (!getIt.isRegistered<ProductDetailDatasource>()) {
    getIt.registerSingleton<ProductDetailDatasource>(ProductDetailDatasource());
  }

  if (!getIt.isRegistered<ProductDetailRepository>()) {
    getIt.registerSingleton<ProductDetailRepository>(
      ProductDetailRepositoryImpl(),
    );
  }

  if (!getIt.isRegistered<GetProductByIdUseCase>()) {
    getIt.registerSingleton<GetProductByIdUseCase>(GetProductByIdUseCase());
  }
}

void unregisterProductDetailInjectionContainer() {
  GetIt.I.unregister<GetProductByIdUseCase>();
  GetIt.I.unregister<ProductDetailRepository>();
  GetIt.I.unregister<ProductDetailDatasource>();
}
