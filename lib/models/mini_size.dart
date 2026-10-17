/// D&D 5e boyut kategorileri.
/// Fiyat = ürünün temel fiyatı (Medium referans) x boyut çarpanı.
enum MiniSize {
  tiny('T', 'Tiny', 'Minik', '25 mm', 0.6),
  small('S', 'Small', 'Küçük', '25 mm', 0.8),
  medium('M', 'Medium', 'Orta', '25 mm', 1.0),
  large('L', 'Large', 'Büyük', '50 mm', 2.2),
  huge('H', 'Huge', 'Devasa', '75 mm', 4.5),
  gargantuan('G', 'Gargantuan', 'Dev', '100 mm', 9.0);

  const MiniSize(
    this.code,
    this.label,
    this.labelTr,
    this.baseDiameter,
    this.multiplier,
  );

  final String code; // JSON'daki kısaltma
  final String label; // D&D'deki İngilizce adı
  final String labelTr;
  final String baseDiameter; // Kaide çapı
  final double multiplier; // Fiyat çarpanı

  static MiniSize fromCode(String code) {
    return MiniSize.values.firstWhere(
      (s) => s.code == code,
      orElse: () => MiniSize.medium,
    );
  }
}
