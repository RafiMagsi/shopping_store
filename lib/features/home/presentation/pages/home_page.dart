import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/app_header.dart';
import '../widgets/hero_banner.dart';
import '../widgets/category_strip.dart';
import '../widgets/flash_sale_section.dart';
import '../widgets/featured_collection.dart';
import '../widgets/trending_section.dart';
import '../widgets/brand_ticker.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/scroll_tilt.dart';
import '../widgets/product_card.dart';
import '../widgets/scroll_reveal.dart';
import '../../domain/entities/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollCtrl = ScrollController();
  final _scrollNotifier = ValueNotifier<double>(0.0);

  double _scrollOffset = 0;
  double _velocity = 0;
  double _lastOffset = 0;
  int _lastMs = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final now = DateTime.now().millisecondsSinceEpoch;
    final dt = (now - _lastMs).clamp(1, 100);
    _velocity = (offset - _lastOffset) / dt * 16;
    _lastOffset = offset;
    _lastMs = now;
    _scrollNotifier.value = offset;
    if ((offset - _scrollOffset).abs() > 0.5) {
      setState(() => _scrollOffset = offset);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _scrollNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        return Scaffold(
          backgroundColor: AppColors.bg,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: AppHeader(
              scrollOffset: _scrollOffset,
              cartCount: state.cartCount,
              onCart: cubit.addToCart,
            ),
          ),
          body: state.status == HomeStatus.loading
              ? const _LoadingShimmer()
              : CustomScrollView(
                  controller: _scrollCtrl,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // ── Hero ────────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: HeroBanner(
                        scrollOffset: _scrollOffset,
                        scrollVelocity: _velocity,
                        slides: state.heroSlides,
                      ),
                    ),

                    // ── Categories ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _SectionTitle(
                        overline: 'BROWSE BY',
                        title: 'Categories',
                        accent: AppColors.champagne,
                        scrollNotifier: _scrollNotifier,
                        r: r,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(8)),
                        child: CategoryStrip(
                          categories: state.categories,
                          selectedIndex: state.selectedCategoryIndex,
                          onSelect: cubit.selectCategory,
                          scrollNotifier: _scrollNotifier,
                        ),
                      ),
                    ),

                    // ── Hot Deals ───────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _SectionTitle(
                        overline: 'TODAY\'S PICKS',
                        title: 'Hot Deals',
                        accent: AppColors.rose,
                        scrollNotifier: _scrollNotifier,
                        r: r,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(28)),
                        child: _HotDealsRow(
                          products: state.hotDeals,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Flash Sale ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _SectionTitle(
                        overline: '⚡ LIMITED TIME',
                        title: 'Flash Sale',
                        accent: AppColors.roseDeep,
                        scrollNotifier: _scrollNotifier,
                        r: r,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(28)),
                        child: FlashSaleSection(
                          items: state.flashSaleItems,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Featured ────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _SectionTitle(
                        overline: 'EDITORIAL',
                        title: 'Featured',
                        accent: AppColors.champagne,
                        scrollNotifier: _scrollNotifier,
                        r: r,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(28)),
                        child: FeaturedCollection(scrollNotifier: _scrollNotifier),
                      ),
                    ),

                    // ── Trending ────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _SectionTitle(
                        overline: 'POPULAR NOW',
                        title: 'Trending',
                        accent: AppColors.ice,
                        scrollNotifier: _scrollNotifier,
                        r: r,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(28)),
                        child: TrendingSection(
                          products: state.trending,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Brands ──────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(20)),
                        child: BrandTicker(
                          brands: state.brands,
                          scrollNotifier: _scrollNotifier,
                        ),
                      ),
                    ),

                    // Footer spacer for bottom nav
                    SliverToBoxAdapter(
                      child: SizedBox(height: r.h(80)),
                    ),
                  ],
                ),

          bottomNavigationBar: ShopBottomNavBar(
            currentIndex: state.bottomNavIndex,
            onTap: cubit.setBottomNav,
          ),
        );
      },
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Simple non-sticky section title
// ───────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String overline;
  final String title;
  final Color accent;
  final ValueNotifier<double> scrollNotifier;
  final R r;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionTitle({
    required this.overline,
    required this.title,
    required this.accent,
    required this.scrollNotifier,
    required this.r,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      scrollNotifier: scrollNotifier,
      fromOffset: const Offset(0, 20),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.w(20), r.h(4), r.w(20), r.h(14)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overline,
                  style: TextStyle(
                    color: accent,
                    fontSize: r.sp(10),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: r.h(2)),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.sp(22),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Text(
                    actionLabel ?? 'See All',
                    style: TextStyle(
                      color: AppColors.champagne,
                      fontSize: r.sp(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: r.w(3)),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.champagne,
                    size: r.sp(11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Hot deals horizontal strip
// ───────────────────────────────────────────────────────────────────────────

class _HotDealsRow extends StatefulWidget {
  final List<Product> products;
  final ValueNotifier<double> scrollNotifier;
  final VoidCallback onAddToCart;

  const _HotDealsRow({
    required this.products,
    required this.scrollNotifier,
    required this.onAddToCart,
  });

  @override
  State<_HotDealsRow> createState() => _HotDealsRowState();
}

class _HotDealsRowState extends State<_HotDealsRow> {
  final _hScrollCtrl = ScrollController();
  final _hScrollNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _hScrollCtrl.addListener(() {
      _hScrollNotifier.value = _hScrollCtrl.offset;
    });
  }

  @override
  void dispose() {
    _hScrollCtrl.dispose();
    _hScrollNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    // Fixed total card height: image(180) + details(100) = 280px
    return SizedBox(
      height: r.h(280),
      child: ListView.builder(
        controller: _hScrollCtrl,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: r.w(16)),
        itemCount: widget.products.length,
        itemBuilder: (_, i) {
          final p = widget.products[i];
          return Padding(
            padding: EdgeInsets.only(right: r.w(12)),
            child: HorizontalTilt3D(
              scrollNotifier: _hScrollNotifier,
              child: SizedBox(
                width: r.w(168),
                child: ProductCard(
                  product: p,
                  width: r.w(168),
                  onAddToCart: widget.onAddToCart,
                  scrollNotifier: widget.scrollNotifier,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Loading shimmer
// ───────────────────────────────────────────────────────────────────────────

class _LoadingShimmer extends StatefulWidget {
  const _LoadingShimmer();

  @override
  State<_LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<_LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Shimmer(height: 480, value: _ctrl.value),
            const SizedBox(height: 20),
            _Shimmer(height: 60, width: 160, value: _ctrl.value, hPad: 20),
            const SizedBox(height: 12),
            _Shimmer(height: 90, value: _ctrl.value),
            const SizedBox(height: 24),
            _Shimmer(height: 60, width: 120, value: _ctrl.value, hPad: 20),
            const SizedBox(height: 12),
            _Shimmer(height: 280, value: _ctrl.value),
          ],
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double height;
  final double? width;
  final double value;
  final double hPad;

  const _Shimmer({
    required this.height, required this.value,
    this.width, this.hPad = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment(value * 3 - 2.5, 0),
            end: Alignment(value * 3 - 1.5, 0),
            colors: const [
              Color(0xFFEFECE8),
              Color(0xFFE2DDD8),
              Color(0xFFEFECE8),
            ],
          ),
        ),
      ),
    );
  }
}
