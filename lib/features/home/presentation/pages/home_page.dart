import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
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

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _scrollCtrl    = ScrollController();
  final _scrollNotifier = ValueNotifier<double>(0.0);

  double _scrollOffset = 0;
  double _velocity     = 0;
  double _lastOffset   = 0;
  int    _lastMs       = 0;

  // ── Entrance animation ──────────────────────────────────────────────────
  late final AnimationController _entranceCtrl;
  bool _entranceStarted = false;

  // Each section's staggered animation — built once in initState
  late final List<Animation<double>> _anim;

  // Stagger timing constants (ms, out of _kTotalMs)
  static const double _kTotalMs = 2200;

  Animation<double> _interval(double startMs, {double durMs = 680}) {
    return CurvedAnimation(
      parent: _entranceCtrl,
      curve: Interval(
        (startMs / _kTotalMs).clamp(0.0, 1.0),
        ((startMs + durMs) / _kTotalMs).clamp(0.0, 1.0),
        curve: Curves.easeOutExpo,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
    _scrollCtrl.addListener(_onScroll);

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Build staggered animations — one per section in page order:
    // 0  hero
    // 1  category title
    // 2  category strip
    // 3  hot deals title
    // 4  hot deals row
    // 5  flash sale title
    // 6  flash sale
    // 7  featured title
    // 8  featured
    // 9  trending title
    // 10 trending grid
    // 11 brand ticker
    _anim = [
      _interval(0),     // hero           — from top
      _interval(180),   // category title — from left
      _interval(270),   // category strip — from left
      _interval(370),   // hot deals title— from right
      _interval(450),   // hot deals row  — from right
      _interval(540),   // flash title    — from bottom
      _interval(610),   // flash sale     — from bottom
      _interval(690),   // featured title — from left
      _interval(760),   // featured       — from left
      _interval(840),   // trending title — from right
      _interval(910),   // trending grid  — from right
      _interval(1020),  // brand ticker   — from bottom
    ];
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final now    = DateTime.now().millisecondsSinceEpoch;
    final dt     = (now - _lastMs).clamp(1, 100);
    _velocity    = (offset - _lastOffset) / dt * 16;
    _lastOffset  = offset;
    _lastMs      = now;
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
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _triggerEntrance() {
    if (_entranceStarted) return;
    _entranceStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        // Fire entrance animation as soon as content is ready
        if (state.status == HomeStatus.loaded) _triggerEntrance();

        return Scaffold(
          backgroundColor: AppColors.bg,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: _Entrance(
              animation: _anim[0], // shares hero timing — header arrives with hero
              fromOffset: const Offset(0, -1.0),
              child: AppHeader(
                scrollOffset: _scrollOffset,
                cartCount: state.cartCount,
                onCart: cubit.addToCart,
              ),
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

                    // ── Hero ─────────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[0],
                        fromOffset: const Offset(0, -0.5),
                        child: HeroBanner(
                          scrollOffset: _scrollOffset,
                          scrollVelocity: _velocity,
                          slides: state.heroSlides,
                        ),
                      ),
                    ),

                    // ── Categories ────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[1],
                        fromOffset: const Offset(-1.5, 0),
                        child: _SectionTitle(
                          overline: 'BROWSE BY',
                          title: 'Categories',
                          accent: AppColors.champagne,
                          r: r,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[2],
                        fromOffset: const Offset(-1.5, 0),
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
                    ),

                    // ── Hot Deals ─────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[3],
                        fromOffset: const Offset(1.5, 0),
                        child: _SectionTitle(
                          overline: "TODAY'S PICKS",
                          title: 'Hot Deals',
                          accent: AppColors.rose,
                          r: r,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[4],
                        fromOffset: const Offset(1.5, 0),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: r.h(28)),
                          child: _HotDealsRow(
                            products: state.hotDeals,
                            scrollNotifier: _scrollNotifier,
                            onAddToCart: cubit.addToCart,
                          ),
                        ),
                      ),
                    ),

                    // ── Flash Sale ────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[5],
                        fromOffset: const Offset(0, 0.7),
                        child: _SectionTitle(
                          overline: '⚡ LIMITED TIME',
                          title: 'Flash Sale',
                          accent: AppColors.roseDeep,
                          r: r,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[6],
                        fromOffset: const Offset(0, 0.6),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: r.h(28)),
                          child: FlashSaleSection(
                            items: state.flashSaleItems,
                            scrollNotifier: _scrollNotifier,
                            onAddToCart: cubit.addToCart,
                          ),
                        ),
                      ),
                    ),

                    // ── Featured ──────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[7],
                        fromOffset: const Offset(-1.5, 0),
                        child: _SectionTitle(
                          overline: 'EDITORIAL',
                          title: 'Featured',
                          accent: AppColors.champagne,
                          r: r,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[8],
                        fromOffset: const Offset(-1.5, 0),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: r.h(28)),
                          child: FeaturedCollection(
                            scrollNotifier: _scrollNotifier,
                          ),
                        ),
                      ),
                    ),

                    // ── Trending ──────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[9],
                        fromOffset: const Offset(1.5, 0),
                        child: _SectionTitle(
                          overline: 'POPULAR NOW',
                          title: 'Trending',
                          accent: AppColors.ice,
                          r: r,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[10],
                        fromOffset: const Offset(1.5, 0),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: r.h(28)),
                          child: TrendingSection(
                            products: state.trending,
                            scrollNotifier: _scrollNotifier,
                            onAddToCart: cubit.addToCart,
                          ),
                        ),
                      ),
                    ),

                    // ── Brand Ticker ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _Entrance(
                        animation: _anim[11],
                        fromOffset: const Offset(0, 0.7),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: r.h(20)),
                          child: BrandTicker(
                            brands: state.brands,
                            scrollNotifier: _scrollNotifier,
                          ),
                        ),
                      ),
                    ),

                    // Footer spacer
                    SliverToBoxAdapter(
                      child: SizedBox(height: r.h(80)),
                    ),
                  ],
                ),

          bottomNavigationBar: _Entrance(
            animation: _anim[0], // arrives with hero
            fromOffset: const Offset(0, 1.0),
            child: ShopBottomNavBar(
              currentIndex: state.bottomNavIndex,
              onTap: cubit.setBottomNav,
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Entrance — ClipRect + FadeTransition + SlideTransition from any direction
// ─────────────────────────────────────────────────────────────────────────────

class _Entrance extends StatelessWidget {
  /// Pre-built [CurvedAnimation] with [Interval] for staggered timing.
  final Animation<double> animation;

  /// Fractional offset to start from.
  /// • Offset(-1.5, 0)  → slides in from the LEFT  (1.5× widget width off-screen)
  /// • Offset( 1.5, 0)  → from the RIGHT
  /// • Offset( 0, -0.5) → from above
  /// • Offset( 0,  0.7) → from below
  final Offset fromOffset;

  final Widget child;

  const _Entrance({
    required this.animation,
    required this.fromOffset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: fromOffset,
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section title — no internal ScrollReveal (entrance handled at page level)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String overline;
  final String title;
  final Color accent;
  final R r;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionTitle({
    required this.overline,
    required this.title,
    required this.accent,
    required this.r,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.w(20), r.h(8), r.w(20), r.h(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overline row with decorative accent line
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: r.w(18),
                height: r.h(2),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: r.w(8)),
              Text(
                overline,
                style: TextStyle(
                  color: accent,
                  fontSize: r.sp(10),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onAction,
                child: Row(
                  children: [
                    Text(
                      actionLabel ?? 'See All',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: r.sp(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: r.w(3)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textMuted,
                      size: r.sp(10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: r.h(6)),
          // Large editorial title
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.sp(32),
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hot deals horizontal strip
// ─────────────────────────────────────────────────────────────────────────────

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
  final _hScrollCtrl     = ScrollController();
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

// ─────────────────────────────────────────────────────────────────────────────
// Loading shimmer
// ─────────────────────────────────────────────────────────────────────────────

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
            _Shimmer(height: 480, value: _ctrl.value),
            const SizedBox(height: 20),
            _Shimmer(height: 60, width: 160, value: _ctrl.value, hPad: 20),
            const SizedBox(height: 12),
            _Shimmer(height: 50, value: _ctrl.value),
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
