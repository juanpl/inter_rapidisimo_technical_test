import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:inter_rapidisimo_technical_test/core/database/sqlite_db.dart';
import 'package:inter_rapidisimo_technical_test/core/error/custom_exception.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

class CartLocalDatasource {
  final SqliteDB _sqliteDB;

  CartLocalDatasource() : _sqliteDB = GetIt.I<SqliteDB>();

  Future<List<Map<String, dynamic>>> getCart() async {
    try {
      final db = await _sqliteDB.database;
      return db.query('cart');
    } catch (_) {
      throw CustomException(
        message: 'Error al leer el carrito',
        code: 'CART_READ_ERROR',
      );
    }
  }

  Future<void> addProduct(ProductModel product, int quantity) async {
    try {
      final db = await _sqliteDB.database;
      final existing = await db.query(
        'cart',
        where: 'product_id = ?',
        whereArgs: [product.id],
      );
      if (existing.isNotEmpty) {
        final currentQuantity = existing.first['quantity'] as int;
        await db.update(
          'cart',
          {'quantity': currentQuantity + quantity},
          where: 'product_id = ?',
          whereArgs: [product.id],
        );
      } else {
        await db.insert('cart', {
          'product_id': product.id,
          'product_json': jsonEncode(product.toJson()),
          'quantity': quantity,
        });
      }
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(
        message: 'Error al agregar producto',
        code: 'CART_ADD_ERROR',
      );
    }
  }

  Future<void> removeProduct(ProductModel product, int quantity) async {
    try {
      final db = await _sqliteDB.database;
      final existing = await db.query(
        'cart',
        where: 'product_id = ?',
        whereArgs: [product.id],
      );
      if (existing.isEmpty) return;
      final newQuantity = (existing.first['quantity'] as int) - quantity;
      if (newQuantity <= 0) {
        await db.delete(
          'cart',
          where: 'product_id = ?',
          whereArgs: [product.id],
        );
      } else {
        await db.update(
          'cart',
          {'quantity': newQuantity},
          where: 'product_id = ?',
          whereArgs: [product.id],
        );
      }
    } on CustomException {
      rethrow;
    } catch (_) {
      throw CustomException(
        message: 'Error al quitar producto',
        code: 'CART_REMOVE_ERROR',
      );
    }
  }
}
