import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category_item.dart';

enum HomeStatus { initial, loading, loaded }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<CategoryItem> categories;
  final List<Product> hotDeals;
  final List<Product> flashSaleItems;
  final List<Product> trending;
  final List<Map<String, dynamic>> heroSlides;
  final List<String> brands;
  final int selectedCategoryIndex;
  final int cartCount;
  final int bottomNavIndex;

  const HomeState({
    this.status = HomeStatus.initial,
    this.categories = const [],
    this.hotDeals = const [],
    this.flashSaleItems = const [],
    this.trending = const [],
    this.heroSlides = const [],
  this.brands = const [],
    this.selectedCategoryIndex = 0,
    this.cartCount = 3,
    this.bottomNavIndex = 0,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CategoryItem>? categories,
    List<Product>? hotDeals,
    List<Product>? flashSaleItems,
    List<Product>? trending,
    List<String>? brands,
    int? selectedCategoryIndex,
    int? cartCount,
    int? bottomNavIndex,
  }) => HomeState(
    status: status ?? this.status,
    categories: categories ?? this.categories,
    hotDeals: hotDeals ?? this.hotDeals,
    flashSaleItems: flashSaleItems ?? this.flashSaleItems,
    trending: trending ?? this.trending,
    heroSlides: heroSlides ?? this.heroSlides,
    brands: brands ?? this.brands,
    selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
    cartCount: cartCount ?? this.cartCount,
    bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
  );

  @override
  List<Object?> get props => [
    status, categories, hotDeals, flashSaleItems,
    trending, heroSlides, brands, selectedCategoryIndex, cartCount, bottomNavIndex,
  ];
}
