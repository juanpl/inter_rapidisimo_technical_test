import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/widget/app_toolbar.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/events/cart_event.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/providers/cart_provider.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/controllers/cart_controller/states/cart_state.dart';
import 'package:inter_rapidisimo_technical_test/features/cart/presentation/widgets/cart_item_widget.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(cartProvider.notifier).add(const LoadCart()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppToolbar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: switch (state) {
          CartLoading() => const Center(child: CircularProgressIndicator()),
          CartError(:final message) => _ErrorBody(
            message: message,
            onRetry: () =>
                ref.read(cartProvider.notifier).add(const LoadCart()),
          ),
          CartSuccess() =>
            state.items.isEmpty
                ? const _EmptyBody()
                : _SuccessBody(state: state, ref: ref),
        },
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.state, required this.ref});

  final CartSuccess state;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartItemWidget(
                item: item,
                isLoading: state.isProductLoading(item.product.id),
                onAdd: () => ref
                    .read(cartProvider.notifier)
                    .add(AddToCart(item.product)),
                onRemove: () => ref
                    .read(cartProvider.notifier)
                    .add(RemoveFromCart(item.product)),
              );
            },
          ),
        ),
        _TotalBar(total: state.totalPrice),
      ],
    );
  }
}

class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.black26),
          SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
