# Zindan Atölyesi – D&D 3D Baskı Minyatür Kataloğu

Flutter ile geliştirilmiş **Mini Katalog Uygulaması**. Dungeons & Dragons masa oyunları için 3D yazıcıyla basılan minyatürleri listeler. Her minyatürün fiyatı, seçilen **D&D boyut kategorisine** (Tiny → Gargantuan) göre hesaplanır.

## Özellikler

- **Ana sayfa:** arama, kategori filtresi (Kahraman / Canavar / Boss / Aksesuar), banner ve `GridView` ile ürün kartları
- **Ürün detayı:** boyut seçimi, seçime göre anında güncellenen fiyat, kaide çapı ve tahmini baskı süresi
- **Sepet:** adet artırma/azaltma, kaydırarak silme, toplam tutar ve sipariş simülasyonu
- **Boyut rehberi:** tüm boyutların kaide çaplarını ve fiyat çarpanlarını gösteren alt panel

## Boyuta göre fiyatlandırma

Her ürünün JSON'da bir `basePrice` değeri vardır (Medium boyut için referans fiyat).
Fiyat = `basePrice × boyut çarpanı`, en yakın 10 TL'ye yuvarlanır.

| Boyut | Kaide | Çarpan |
|---|---|---|
| Tiny (Minik) | 25 mm | ×0.6 |
| Small (Küçük) | 25 mm | ×0.8 |
| Medium (Orta) | 25 mm | ×1.0 |
| Large (Büyük) | 50 mm | ×2.2 |
| Huge (Devasa) | 75 mm | ×4.5 |
| Gargantuan (Dev) | 100 mm | ×9.0 |

Örnek: Kırmızı Ejderha (`basePrice: 250`) → Large ₺550, Huge ₺1.130, Gargantuan ₺2.250.

## Kullanılan Flutter sürümü

- Flutter **3.27** veya üzeri (geliştirme: Flutter 3.x stable, Dart 3)
- Ekstra paket yok, yalnızca `material.dart`

> Kendi sürümünü `flutter --version` ile kontrol edip bu satırı güncelle.

## Çalıştırma adımları

```bash
# 1. Depoyu klonla
git clone https://github.com/<kullanici-adi>/dnd_mini_katalog.git
cd dnd_mini_katalog

# 2. Android/iOS platform klasörlerini oluştur (ilk seferde)
flutter create .

# 3. Bağımlılıkları yükle
flutter pub get

# 4. Emülatörü aç veya telefonu bağla, sonra çalıştır
flutter run
```

## Proje yapısı

```
lib/
├── main.dart                  # MaterialApp, tema, named routes
├── theme.dart                 # Renkler, tema, fiyat formatı
├── models/
│   ├── mini_size.dart         # D&D boyutları + fiyat çarpanları
│   ├── product.dart           # Ürün modeli, fromJson / toJson, priceFor()
│   └── cart_item.dart
├── data/
│   ├── product_repository.dart  # assets'teki JSON'u okur
│   └── cart.dart                # ChangeNotifier ile sepet state'i
├── screens/
│   ├── home_screen.dart       # Liste, arama, filtre, GridView
│   ├── detail_screen.dart     # Route Arguments ile gelen ürün
│   └── cart_screen.dart
└── widgets/
    ├── product_card.dart
    └── cart_button.dart       # Sepet sayısı rozetli buton
assets/
├── data/products.json         # Ürün verisi (JSON simülasyonu)
└── images/                    # Ürün ve banner görselleri
```
