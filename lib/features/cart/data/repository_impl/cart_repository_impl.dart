import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/domain/entities/cart_product_entity.dart';
import '../../../product_catalog/domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/local_datasource.dart';
import '../models/cart_product_model.dart';

class CartRepositoryImpl implements CartRepository {
  final LocalDatasource _localDatasource;

  CartRepositoryImpl() : _localDatasource = GetIt.I<LocalDatasource>();

  @override
  Future<void> addProduct(ProductEntity product, int quantity) async {
    try {
      final cartProductEntity = CartProductEntity(
        product: product,
        quantity: quantity,
      );
      final cartProductModel = CartProductModel.fromEntity(cartProductEntity);
      final cartProductJson = cartProductModel.toJson();
      await _localDatasource.addProduct(cartProductJson, quantity);
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(
        message: 'CartRepositoryImpl_addProduct_Error',
        code: 'UNKNOWN',
      );
    }
  }

  @override
  Future<List<CartProductEntity>> getCart() async {
    try {
      final data = await _localDatasource.getCart();
      final List<CartProductModel> dataModel = data
          .map((cartProductJson) => CartProductModel.fromJson(cartProductJson))
          .toList();
      final dataEntity = dataModel
          .map(
            (cartProductModel) => CartProductEntity.fromModel(cartProductModel),
          )
          .toList();
      return dataEntity;
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(
        message: 'CartRepositoryImpl_getCart_Error',
        code: 'UNKNOWN',
      );
    }
  }

  @override
  Future<void> removeProduct(ProductEntity product, int quantity) async {
    try {
      final cartProductEntity = CartProductEntity(
        product: product,
        quantity: quantity,
      );
      final cartProductModel = CartProductModel.fromEntity(cartProductEntity);
      final cartProductJson = cartProductModel.toJson();
      await _localDatasource.removeProduct(cartProductJson, quantity);
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(
        message: 'CartRepositoryImpl_removeProduct_Error',
        code: 'UNKNOWN',
      );
    }
  }
}
