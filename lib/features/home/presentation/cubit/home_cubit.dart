import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/home_mock_data.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeMockData mockData;

  HomeCubit({required this.mockData}) : super(const HomeState());

  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(
      status: HomeStatus.loaded,
      heroSlides: mockData.heroSlides,
      categories: mockData.categories,
      hotDeals: mockData.hotDeals,
      flashSaleItems: mockData.flashSaleItems,
      trending: mockData.trending,
      brands: mockData.brands,
    ));
  }

  void selectCategory(int index) {
    final updated = state.categories.asMap().entries.map((e) =>
      e.value.copyWith(isSelected: e.key == index),
    ).toList();
    emit(state.copyWith(categories: updated, selectedCategoryIndex: index));
  }

  void toggleFavorite(String productId) {
    final updated = state.hotDeals.map((p) =>
      p.id == productId ? p.copyWith(isFavorite: !p.isFavorite) : p,
    ).toList();
    emit(state.copyWith(hotDeals: updated));
  }

  void addToCart() => emit(state.copyWith(cartCount: state.cartCount + 1));

  void setBottomNav(int index) => emit(state.copyWith(bottomNavIndex: index));
}
