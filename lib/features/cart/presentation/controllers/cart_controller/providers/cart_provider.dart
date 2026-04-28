import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/notifiers/cart_notifier.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/states/cart_state.dart';

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
