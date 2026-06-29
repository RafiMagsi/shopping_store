import 'package:flutter/material.dart';
import '../domain/entities/product.dart';
import '../domain/entities/category_item.dart';

/// Unsplash image URLs (stable photo IDs, free to use)
class _Img {
  static const headphones =
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&h=600&fit=crop&q=80';
  static const sneakers =
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&h=600&fit=crop&q=80';
  static const watch =
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&h=600&fit=crop&q=80';
  static const laptop =
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&h=600&fit=crop&q=80';
  static const handbag =
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&h=600&fit=crop&q=80';
  static const fragrance =
      'https://images.unsplash.com/photo-1541643600914-78b084683702?w=600&h=600&fit=crop&q=80';
  static const camera =
      'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&h=600&fit=crop&q=80';
  static const ring =
      'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600&h=600&fit=crop&q=80';
  static const speaker =
      'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=600&h=600&fit=crop&q=80';
  static const tablet =
      'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600&h=600&fit=crop&q=80';
  static const jacket =
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&h=600&fit=crop&q=80';
  static const shoes2 =
      'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=600&h=600&fit=crop&q=80';
  static const airpods =
      'https://images.unsplash.com/photo-1606741965326-cb990ae01bb2?w=600&h=600&fit=crop&q=80';

  // Hero banner images (portrait format)
  static const hero1 =
      'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=800&h=1100&fit=crop&q=85';
  static const hero2 =
      'https://images.unsplash.com/photo-1468495244123-6c6c332eeece?w=800&h=1100&fit=crop&q=85';
  static const hero3 =
      'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=800&h=1100&fit=crop&q=85';
}

class HomeMockData {
  List<CategoryItem> get categories => const [
    CategoryItem(id: 'all', label: 'All', emoji: '✦', color: Color(0xFF9B7B63)),
    CategoryItem(
      id: 'electronics',
      label: 'Electronics',
      emoji: '⚡',
      color: Color(0xFF778899),
    ),
    CategoryItem(
      id: 'fashion',
      label: 'Fashion',
      emoji: '👗',
      color: Color(0xFFB88474),
    ),
    CategoryItem(
      id: 'beauty',
      label: 'Beauty',
      emoji: '✨',
      color: Color(0xFFC6A993),
    ),
    CategoryItem(
      id: 'sports',
      label: 'Sports',
      emoji: '🏃',
      color: Color(0xFF7E9581),
    ),
    CategoryItem(
      id: 'home',
      label: 'Home',
      emoji: '🏠',
      color: Color(0xFFCBBBAA),
    ),
    CategoryItem(
      id: 'luxury',
      label: 'Luxury',
      emoji: '💎',
      color: Color(0xFFD0B39E),
    ),
  ];

  List<Map<String, dynamic>> get heroSlides => [
    {
      'imageUrl': _Img.hero1,
      'productUrl': _Img.handbag,
      'emoji': '👜',
      'tag': 'SUMMER DROP',
      'title': 'Elevate\nYour Style',
      'subtitle': 'Curated designer pieces for everyday wear',
      'cta': 'Shop Now',
      'accent': const Color(0xFF9B7B63),
    },
    {
      'imageUrl': _Img.hero2,
      'productUrl': _Img.headphones,
      'emoji': '🎧',
      'tag': 'TECH LAUNCH',
      'title': 'Next-Gen\nDevices',
      'subtitle': 'Premium tech built for work, travel, and play',
      'cta': 'Explore Tech',
      'accent': const Color(0xFF778899),
    },
    {
      'imageUrl': _Img.hero3,
      'productUrl': _Img.sneakers,
      'emoji': '👟',
      'tag': 'FLASH DROPS',
      'title': 'Move Fast,\nSave Big',
      'subtitle': 'Limited-time sneaker drops and daily markdowns',
      'cta': 'View Deals',
      'accent': const Color(0xFFB88474),
    },
  ];

  List<Product> get hotDeals => const [
    Product(
      id: 'p1',
      name: 'QuietComfort Ultra',
      brand: 'Bose',
      price: 449,
      originalPrice: 599,
      rating: 4.9,
      reviews: 2841,
      soldPercent: 72,
      badge: 'HOT',
      gradientStart: Color(0xFF1A1A3E),
      gradientEnd: Color(0xFF0D0D2E),
      emoji: '🎧',
      imageUrl: _Img.headphones,
      accentColor: Color(0xFF778899),
      tags: ['wireless'],
    ),
    Product(
      id: 'p2',
      name: 'Free RN Flyknit',
      brand: 'Nike',
      price: 159,
      originalPrice: 220,
      rating: 4.7,
      reviews: 1203,
      soldPercent: 55,
      badge: 'SALE',
      gradientStart: Color(0xFF1A2E1A),
      gradientEnd: Color(0xFF0D1E0D),
      emoji: '👟',
      imageUrl: _Img.sneakers,
      accentColor: Color(0xFFB88474),
      tags: ['running'],
    ),
    Product(
      id: 'p3',
      name: 'Royal Oak',
      brand: 'Audemars',
      price: 1899,
      originalPrice: 2400,
      rating: 4.9,
      reviews: 412,
      soldPercent: 30,
      badge: 'NEW',
      gradientStart: Color(0xFF2E2010),
      gradientEnd: Color(0xFF1E1008),
      emoji: '⌚',
      imageUrl: _Img.watch,
      accentColor: Color(0xFFC6A993),
      tags: ['luxury'],
    ),
    Product(
      id: 'p4',
      name: 'MacBook Pro M4',
      brand: 'Apple',
      price: 1799,
      originalPrice: 2199,
      rating: 4.9,
      reviews: 3201,
      soldPercent: 38,
      badge: 'HOT',
      gradientStart: Color(0xFF1A1A2E),
      gradientEnd: Color(0xFF0D0D20),
      emoji: '💻',
      imageUrl: _Img.laptop,
      accentColor: Color(0xFF9B7B63),
      tags: ['laptop'],
    ),
    Product(
      id: 'p5',
      name: 'Loewe Puzzle Bag',
      brand: 'Loewe',
      price: 1250,
      originalPrice: 1550,
      rating: 4.8,
      reviews: 621,
      soldPercent: 0,
      badge: 'NEW',
      gradientStart: Color(0xFF2E180A),
      gradientEnd: Color(0xFF1E0E04),
      emoji: '👜',
      imageUrl: _Img.handbag,
      accentColor: Color(0xFFD0B39E),
      tags: ['luxury'],
    ),
    Product(
      id: 'p6',
      name: 'Bleu de Chanel',
      brand: 'Chanel',
      price: 180,
      originalPrice: 240,
      rating: 4.8,
      reviews: 1876,
      soldPercent: 65,
      badge: 'SALE',
      gradientStart: Color(0xFF1A1040),
      gradientEnd: Color(0xFF0A0828),
      emoji: '✨',
      imageUrl: _Img.fragrance,
      accentColor: Color(0xFFB88474),
      tags: ['beauty'],
    ),
  ];

  List<Product> get flashSaleItems => const [
    Product(
      id: 'f1',
      name: 'Sony WH-1000XM5',
      brand: 'Sony',
      price: 198,
      originalPrice: 399,
      rating: 4.9,
      reviews: 5420,
      soldPercent: 88,
      badge: 'FLASH',
      gradientStart: Color(0xFF101020),
      gradientEnd: Color(0xFF080818),
      emoji: '🎵',
      imageUrl: _Img.headphones,
      accentColor: Color(0xFF778899),
    ),
    Product(
      id: 'f2',
      name: 'Nike Air Jordan 1',
      brand: 'Nike',
      price: 129,
      originalPrice: 220,
      rating: 4.8,
      reviews: 4210,
      soldPercent: 74,
      badge: 'FLASH',
      gradientStart: Color(0xFF1A0810),
      gradientEnd: Color(0xFF100508),
      emoji: '👟',
      imageUrl: _Img.shoes2,
      accentColor: Color(0xFFB88474),
    ),
    Product(
      id: 'f3',
      name: 'iPad Air M2',
      brand: 'Apple',
      price: 499,
      originalPrice: 749,
      rating: 4.9,
      reviews: 2987,
      soldPercent: 91,
      badge: 'FLASH',
      gradientStart: Color(0xFF0A1020),
      gradientEnd: Color(0xFF060A14),
      emoji: '📱',
      imageUrl: _Img.tablet,
      accentColor: Color(0xFFC6A993),
    ),
  ];

  List<Product> get trending => const [
    Product(
      id: 't1',
      name: 'Roam Speaker',
      brand: 'Sonos',
      price: 549,
      originalPrice: 699,
      rating: 4.7,
      reviews: 1203,
      soldPercent: 0,
      gradientStart: Color(0xFF102030),
      gradientEnd: Color(0xFF081018),
      emoji: '🔊',
      imageUrl: _Img.speaker,
      badge: 'HOT',
      accentColor: Color(0xFF7E9581),
    ),
    Product(
      id: 't2',
      name: 'AirPods Pro',
      brand: 'Apple',
      price: 279,
      originalPrice: 350,
      rating: 4.8,
      reviews: 3421,
      soldPercent: 0,
      gradientStart: Color(0xFF1A1030),
      gradientEnd: Color(0xFF0D0820),
      emoji: '🎧',
      imageUrl: _Img.airpods,
      badge: 'NEW',
      accentColor: Color(0xFF778899),
    ),
    Product(
      id: 't3',
      name: 'Fujifilm X100VI',
      brand: 'Fujifilm',
      price: 1599,
      originalPrice: 1799,
      rating: 4.9,
      reviews: 876,
      soldPercent: 0,
      gradientStart: Color(0xFF201510),
      gradientEnd: Color(0xFF140D08),
      emoji: '📷',
      imageUrl: _Img.camera,
      badge: 'SALE',
      accentColor: Color(0xFFD0B39E),
    ),
    Product(
      id: 't4',
      name: 'Wool Blend Jacket',
      brand: 'Max Mara',
      price: 450,
      originalPrice: 490,
      rating: 4.9,
      reviews: 234,
      soldPercent: 0,
      gradientStart: Color(0xFF301010),
      gradientEnd: Color(0xFF200808),
      emoji: '🧥',
      imageUrl: _Img.jacket,
      badge: '',
      accentColor: Color(0xFFB88474),
    ),
    Product(
      id: 't5',
      name: 'Juste un Clou Ring',
      brand: 'Cartier',
      price: 2800,
      originalPrice: 3200,
      rating: 5.0,
      reviews: 189,
      soldPercent: 0,
      gradientStart: Color(0xFF28180A),
      gradientEnd: Color(0xFF1A1006),
      emoji: '💍',
      imageUrl: _Img.ring,
      badge: 'NEW',
      accentColor: Color(0xFFC6A993),
    ),
    Product(
      id: 't6',
      name: 'Mini Jodie Bag',
      brand: 'Bottega Veneta',
      price: 1950,
      originalPrice: 2200,
      rating: 4.8,
      reviews: 312,
      soldPercent: 0,
      gradientStart: Color(0xFF201810),
      gradientEnd: Color(0xFF140E08),
      emoji: '👜',
      imageUrl: _Img.handbag,
      badge: '',
      accentColor: Color(0xFFD0B39E),
    ),
  ];

  List<String> get brands => [
    'APPLE',
    'NIKE',
    'CHANEL',
    'LOUIS VUITTON',
    'GUCCI',
    'ROLEX',
    'PRADA',
    'HERMÈS',
    'ADIDAS',
    'SONY',
  ];
}
