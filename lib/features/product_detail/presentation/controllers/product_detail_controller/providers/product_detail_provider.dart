import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/notifiers/product_detail_notifier.dart';
import 'package:inter_rapidisimo_technical_test/features/product_detail/presentation/controllers/product_detail_controller/states/product_detail_state.dart';

final productDetailProvider = NotifierProvider.family<
  ProductDetailNotifier,
  ProductDetailState,
  int
>(ProductDetailNotifier.new);
