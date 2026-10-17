import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../models/cart_item.dart';
import '../theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';

  Future<void> _checkout(BuildContext context) async {
    final total = Cart.instance.total;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.local_shipping_outlined, color: AppColors.gold),
        title: const Text('Sipariş alındı!'),
        content: Text(
          'Toplam ${formatPrice(total)} tutarındaki minyatürlerin baskı '
          'kuyruğuna eklendi.\n\n(Bu bir simülasyondur, gerçek ödeme alınmaz.)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
    Cart.instance.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Cart.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Sepet')),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.isEmpty) return const _EmptyCart();

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _CartTile(item: cart.items[index]),
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border:
                        Border(top: BorderSide(color: AppColors.surfaceHigh)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${cart.count} minyatür',
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                          const Spacer(),
                          const Text('Toplam  '),
                          Text(
                            formatPrice(cart.total),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => _checkout(context),
                        child: const Text('Siparişi tamamla'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = Cart.instance;

    return Dismissible(
      key: ValueKey('${item.product.id}-${item.size.code}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cart.remove(item),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.crimson,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item.product.image,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${item.size.label} · ${item.size.baseDiameter} kaide',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatPrice(item.total),
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => cart.decrease(item),
                icon: Icon(
                  item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                ),
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => cart.increase(item),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            const Text(
              'Sepetin boş',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Maceraya hazırlanmak için birkaç minyatür ekle.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kataloğa dön'),
            ),
          ],
        ),
      ),
    );
  }
}
