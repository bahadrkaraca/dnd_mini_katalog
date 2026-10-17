import 'mini_size.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final String tagline;
  final String description;
  final double basePrice; // Medium boyut için referans fiyat (TL)
  final String image;
  final List<MiniSize> sizes; // Bu figürün basılabildiği boyutlar
  final String material;
  final int printHours; // Medium/ilk boyut için tahmini baskı süresi

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.basePrice,
    required this.image,
    required this.sizes,
    required this.material,
    required this.printHours,
  });

  /// Seçilen boyuta göre fiyat (10 TL'ye yuvarlanır).
  double priceFor(MiniSize size) {
    final raw = basePrice * size.multiplier;
    return (raw / 10).round() * 10;
  }

  /// Listede gösterilecek en düşük fiyat.
  double get startingPrice => priceFor(sizes.first);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      basePrice: (json['basePrice'] as num).toDouble(),
      image: json['image'] as String,
      sizes: (json['sizes'] as List<dynamic>)
          .map((code) => MiniSize.fromCode(code as String))
          .toList(),
      material: json['material'] as String? ?? 'Reçine',
      printHours: json['printHours'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tagline': tagline,
      'description': description,
      'basePrice': basePrice,
      'image': image,
      'sizes': sizes.map((s) => s.code).toList(),
      'material': material,
      'printHours': printHours,
    };
  }
}
