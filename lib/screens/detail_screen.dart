import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../models/mini_size.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/cart_button.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  static const routeName = '/detail';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  MiniSize? _selectedSize;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Route Arguments: ana sayfadan gönderilen ürün
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final size = _selectedSize ?? product.sizes.first;
    final unitPrice = product.priceFor(size);
    final printHours = (product.printHours * size.multiplier).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: const [CartButton(), SizedBox(width: 4)],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Hero(
              tag: 'product-${product.id}',
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.gold,
                    letterSpacing: 1.5,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.tagline,
                  style: const TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 20),

                // Boyut seçimi -> fiyat anında güncellenir (setState)
                const Text(
                  'Boyut seç',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in product.sizes)
                      _SizeOption(
                        size: s,
                        price: product.priceFor(s),
                        selected: s == size,
                        onTap: () => setState(() => _selectedSize = s),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Açıklama',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  product.description,
                  style: const TextStyle(height: 1.5, color: AppColors.text),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Özellikler',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _SpecBox(label: 'MALZEME', value: product.material),
                    const SizedBox(width: 8),
                    _SpecBox(label: 'KAİDE', value: size.baseDiameter),
                    const SizedBox(width: 8),
                    _SpecBox(label: 'BASKI', value: '~$printHours saat'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.surfaceHigh)),
          ),
          child: Row(
            children: [
              _QuantityStepper(
                value: _quantity,
                onMinus: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                onPlus: () => setState(() => _quantity++),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => _addToCart(product, size),
                  child: Text(
                    'Sepete ekle · ${formatPrice(unitPrice * _quantity)}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(Product product, MiniSize size) {
    Cart.instance.add(product, size, quantity: _quantity);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$_quantity × ${product.name} (${size.label}) sepete eklendi'),
          action: SnackBarAction(
            label: 'SEPET',
            onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),
        ),
      );
    setState(() => _quantity = 1);
  }
}

class _SizeOption extends StatelessWidget {
  const _SizeOption({
    required this.size,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final MiniSize size;
  final double price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.surfaceHigh,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              size.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? AppColors.gold : AppColors.text,
              ),
            ),
            Text(
              size.baseDiameter,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              formatPrice(price),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecBox extends StatelessWidget {
  const _SpecBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.surfaceHigh),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(onPressed: onMinus, icon: const Icon(Icons.remove)),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(onPressed: onPlus, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
