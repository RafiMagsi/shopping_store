import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviews;
  final int soldPercent;
  final Color gradientStart;
  final Color gradientEnd;
  final String emoji;
  final String imageUrl;     // Unsplash / network image URL
  final bool isFavorite;
  final String badge;
  final List<String> tags;
  final Color accentColor;   // dominant color for glow effects

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviews,
    required this.soldPercent,
    required this.gradientStart,
    required this.gradientEnd,
    required this.emoji,
    this.imageUrl = '',
    this.isFavorite = false,
    this.badge = '',
    this.tags = const [],
    this.accentColor = const Color(0xFF7C3AED),
  });

  double get discountPercent =>
      originalPrice > 0 ? ((originalPrice - price) / originalPrice * 100) : 0;

  bool get hasDiscount => originalPrice > price;
  bool get hasImage => imageUrl.isNotEmpty;

  Product copyWith({bool? isFavorite}) => Product(
        id: id, name: name, brand: brand,
        price: price, originalPrice: originalPrice,
        rating: rating, reviews: reviews,
        soldPercent: soldPercent,
        gradientStart: gradientStart, gradientEnd: gradientEnd,
        emoji: emoji, imageUrl: imageUrl,
        isFavorite: isFavorite ?? this.isFavorite,
        badge: badge, tags: tags, accentColor: accentColor,
      );

  @override
  List<Object?> get props => [id, isFavorite];
}
