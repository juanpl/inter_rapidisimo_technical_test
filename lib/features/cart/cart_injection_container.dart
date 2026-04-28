import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/data/datasources/local_datasource.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/data/repository_impl/cart_repository_impl.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/repositories/cart_repository.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/add_product_to_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';

final getIt = GetIt.instance;

void cartInjectionContainer(GetIt getIt) {
  if (!getIt.isRegistered<LocalDatasource>()) {
    getIt.registerSingleton<LocalDatasource>(LocalDatasource());
  }

  if (!getIt.isRegistered<CartRepository>()) {
    getIt.registerSingleton<CartRepository>(CartRepositoryImpl());
  }

  if (!getIt.isRegistered<AddProductToCartUseCase>()) {
    getIt.registerSingleton<AddProductToCartUseCase>(AddProductToCartUseCase());
  }

  if (!getIt.isRegistered<GetCartUseCase>()) {
    getIt.registerSingleton<GetCartUseCase>(GetCartUseCase());
  }

  if (!getIt.isRegistered<RemoveProductFromCartUseCase>()) {
    getIt.registerSingleton<RemoveProductFromCartUseCase>(
      RemoveProductFromCartUseCase(),
    );
  }
}

void unregisterCartInjectionContainer() {
  GetIt.I.unregister<LocalDatasource>();
  GetIt.I.unregister<CartRepository>();
  GetIt.I.unregister<AddProductToCartUseCase>();
  GetIt.I.unregister<GetCartUseCase>();
  GetIt.I.unregister<RemoveProductFromCartUseCase>();
}
