import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/mini_size.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _categories = ['Tümü', 'Kahraman', 'Canavar', 'Boss', 'Aksesuar'];

  List<Product> _allProducts = [];
  bool _loading = true;
  String _query = '';
  String _category = 'Tümü';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final products = await ProductRepository.loadProducts();
    if (!mounted) return;
    setState(() {
      _allProducts = products;
      _loading = false;
    });
  }

  // Basit arama + kategori filtresi
  List<Product> get _filtered {
    final q = _query.trim().toLowerCase();
    return _allProducts.where((p) {
      final matchesCategory = _category == 'Tümü' || p.category == _category;
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.tagline.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (_) => const _SizeGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _filtered;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zindan Atölyesi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(
              'Masana uygun minyatürü bul',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Boyut rehberi',
            onPressed: _showSizeGuide,
            icon: const Icon(Icons.straighten),
          ),
          const CartButton(),
          const SizedBox(width: 4),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Arama
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Minyatür ara (ör. ejderha)',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/images/banner.png'),
                ),
                const SizedBox(height: 16),

                // Kategori filtresi
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final c = _categories[index];
                      return ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Ürün ızgarası
                if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Text(
                        'Bu zindanda aradığın yaratık yok.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        // Route Arguments ile ürünü detay sayfasına taşı
                        onTap: () => Navigator.pushNamed(
                          context,
                          DetailScreen.routeName,
                          arguments: product,
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}

class _SizeGuideSheet extends StatelessWidget {
  const _SizeGuideSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Boyut Rehberi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fiyat, figürün D&D boyut kategorisine göre belirlenir. '
            'Orta (Medium) boyut temel fiyattır.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          for (final size in MiniSize.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.surfaceHigh,
                    child: Text(
                      size.code,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text('${size.label} (${size.labelTr})')),
                  Text(
                    size.baseDiameter,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 48,
                    child: Text(
                      '×${size.multiplier}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
