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
    _velocity = (offset - _lastOffset) / dt * 16; // normalize to ~60fps frame
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
            preferredSize: const Size.fromHeight(80),
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
                    _SectionHeader(
                      overline: 'BROWSE',
                      title: 'Categories',
                      icon: Icons.grid_view_rounded,
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
                    _SectionHeader(
                      overline: '🔥 TODAY',
                      title: 'Hot Deals',
                      icon: Icons.local_fire_department_rounded,
                      accentColor: AppColors.pink,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(8)),
                        child: _HotDealsWithTilt(
                          products: state.hotDeals,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Flash Sale ──────────────────────────────────────
                    _SectionHeader(
                      overline: '⚡ LIMITED',
                      title: 'Flash Sale',
                      icon: Icons.bolt_rounded,
                      accentColor: AppColors.pinkDeep,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(8)),
                        child: FlashSaleSection(
                          items: state.flashSaleItems,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Featured ────────────────────────────────────────
                    _SectionHeader(
                      overline: '✦ EDITORIAL',
                      title: 'Featured',
                      icon: Icons.auto_awesome_rounded,
                      accentColor: AppColors.amber,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(8)),
                        child: FeaturedCollection(
                          scrollNotifier: _scrollNotifier,
                        ),
                      ),
                    ),

                    // ── Trending ────────────────────────────────────────
                    _SectionHeader(
                      overline: '📈 POPULAR',
                      title: 'Trending',
                      icon: Icons.trending_up_rounded,
                      accentColor: AppColors.emerald,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: r.h(8)),
                        child: TrendingSection(
                          products: state.trending,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Brands ──────────────────────────────────────────
                    _SectionHeader(
                      overline: 'PARTNERS',
                      title: 'Top Brands',
                      icon: Icons.verified_rounded,
                    ),
                    SliverToBoxAdapter(
                      child: BrandTicker(
                        brands: state.brands,
                        scrollNotifier: _scrollNotifier,
                      ),
                    ),

                    // Footer spacer
                    const SliverToBoxAdapter(child: SizedBox(height: 60)),
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
// Sticky morphing section header
// ───────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String overline;
  final String title;
  final IconData icon;
  final Color accentColor;

  const _SectionHeader({
    required this.overline,
    required this.title,
    required this.icon,
    this.accentColor = AppColors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SectionDelegate(
        overline: overline,
        title: title,
        icon: icon,
        accent: accentColor,
      ),
    );
  }
}

class _SectionDelegate extends SliverPersistentHeaderDelegate {
  final String overline;
  final String title;
  final IconData icon;
  final Color accent;

  const _SectionDelegate({
    required this.overline,
    required this.title,
    required this.icon,
    required this.accent,
  });

  @override
  double get maxExtent => 80.0;
  @override
  double get minExtent => 52.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final r = context.r;
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: t * 24, sigmaY: t * 24,
        ),
        child: Container(
          color: AppColors.bg.withOpacity(0.7 + t * 0.28),
          child: Stack(
            children: [
              // Subtle bottom border that fades in as sticky
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Opacity(
                  opacity: t,
                  child: Container(
                    height: 1,
                    color: AppColors.glassBorder,
                  ),
                ),
              ),

              // Accent line on left when sticky
              Positioned(
                left: 0, top: 12, bottom: 12,
                child: AnimatedOpacity(
                  opacity: t,
                  duration: Duration.zero,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content — morphs from large to compact
              Padding(
                padding: EdgeInsets.only(
                  left: r.w(20 + t * 8),
                  right: r.w(20),
                  top: r.h(10 + (1 - t) * 8),
                  bottom: r.h(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon (visible when compact)
                    if (t > 0.3)
                      Padding(
                        padding: EdgeInsets.only(right: r.w(10)),
                        child: Opacity(
                          opacity: ((t - 0.3) / 0.7).clamp(0.0, 1.0),
                          child: Icon(icon, color: accent, size: r.sp(16)),
                        ),
                      ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Overline fades out as compact
                        if (t < 0.8)
                          Opacity(
                            opacity: (1 - t / 0.8).clamp(0.0, 1.0),
                            child: Text(
                              overline,
                              style: AppTextStyles.overline.copyWith(
                                color: accent,
                                fontSize: r.sp(9),
                              ),
                            ),
                          ),

                        // Title — always visible, scales down
                        Text(
                          title,
                          style: AppTextStyles.h1.copyWith(
                            fontSize: r.sp(22 - t * 6),
                            letterSpacing: -0.5 - t * 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SectionDelegate old) =>
      old.title != title || old.accent != accent;
}

// ───────────────────────────────────────────────────────────────────────────
// Hot deals horizontal list with HorizontalTilt3D per card
// ───────────────────────────────────────────────────────────────────────────

class _HotDealsWithTilt extends StatefulWidget {
  final List<Product> products;
  final ValueNotifier<double> scrollNotifier;
  final VoidCallback onAddToCart;

  const _HotDealsWithTilt({
    required this.products,
    required this.scrollNotifier,
    required this.onAddToCart,
  });

  @override
  State<_HotDealsWithTilt> createState() => _HotDealsWithTiltState();
}

class _HotDealsWithTiltState extends State<_HotDealsWithTilt> {
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

    return SizedBox(
      height: r.h(296),
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
              child: ProductCard(
                product: p,
                width: r.w(172),
                onAddToCart: widget.onAddToCart,
                scrollNotifier: widget.scrollNotifier,
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBlock(height: 520, value: _ctrl.value),
            const SizedBox(height: 16),
            _ShimmerBlock(height: 72, width: 180, value: _ctrl.value, hPad: 20),
            const SizedBox(height: 8),
            _ShimmerBlock(height: 80, value: _ctrl.value),
            const SizedBox(height: 16),
            _ShimmerBlock(height: 72, width: 150, value: _ctrl.value, hPad: 20),
            const SizedBox(height: 8),
            _ShimmerBlock(height: 290, value: _ctrl.value),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  final double height;
  final double? width;
  final double value;
  final double hPad;

  const _ShimmerBlock({
    required this.height,
    required this.value,
    this.width,
    this.hPad = 0,
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
              Color(0xFF141414),
              Color(0xFF202020),
              Color(0xFF141414),
            ],
          ),
        ),
      ),
    );
  }
}
