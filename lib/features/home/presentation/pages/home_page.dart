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
import '../widgets/scroll_reveal.dart';
import '../widgets/section_snap_scroll_physics.dart';
import '../widgets/product_card.dart';
import '../widgets/sparkle_layer.dart';
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
  final _scrollViewKey = GlobalKey();
  final _scrollCtrl = ScrollController();
  final _scrollNotifier = ValueNotifier<double>(0.0);
  final _heroKey = GlobalKey();
  final _categoriesKey = GlobalKey();
  final _hotDealsKey = GlobalKey();
  final _flashSaleKey = GlobalKey();
  final _featuredKey = GlobalKey();
  final _trendingKey = GlobalKey();
  final _brandsKey = GlobalKey();

  double _scrollOffset = 0;
  double _velocity = 0;
  double _lastOffset = 0;
  int _lastMs = 0;
  List<double> _sectionAnchors = const [0];
  bool _sectionMeasureScheduled = false;

  // ── Entrance animation ──────────────────────────────────────────────────
  late final AnimationController _entranceCtrl;
  bool _entranceStarted = false;

  // Header, hero, and bottom nav use page-entry animation.
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

    _anim = [_interval(0), _interval(180), _interval(340)];
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

  void _scheduleSectionMeasurement() {
    if (_sectionMeasureScheduled) return;
    _sectionMeasureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sectionMeasureScheduled = false;
      _measureSectionAnchors();
    });
  }

  void _measureSectionAnchors() {
    if (!mounted) return;
    final scrollBox =
        _scrollViewKey.currentContext?.findRenderObject() as RenderBox?;
    if (scrollBox == null || !scrollBox.attached) return;

    final scrollTop = scrollBox.localToGlobal(Offset.zero).dy;
    final keys = [
      _heroKey,
      _categoriesKey,
      _hotDealsKey,
      _flashSaleKey,
      _featuredKey,
      _trendingKey,
      _brandsKey,
    ];

    final anchors = <double>[];
    for (final key in keys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      final dy = box.localToGlobal(Offset.zero).dy - scrollTop;
      anchors.add((_scrollCtrl.hasClients ? _scrollCtrl.offset : 0) + dy);
    }

    if (_sameAnchors(_sectionAnchors, anchors)) return;
    setState(() => _sectionAnchors = anchors);
  }

  bool _sameAnchors(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > 1.5) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        // Fire entrance animation as soon as content is ready
        if (state.status == HomeStatus.loaded) _triggerEntrance();
        if (state.status == HomeStatus.loaded) _scheduleSectionMeasurement();
        final snapInset = r.h(82);
        final compactSectionGap = r.h(18);
        final sectionGap = r.h(28);

        return Scaffold(
          backgroundColor: AppColors.bg,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: _Entrance(
              animation:
                  _anim[0], // shares hero timing — header arrives with hero
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
                  key: _scrollViewKey,
                  controller: _scrollCtrl,
                  physics: SectionSnapScrollPhysics(
                    anchors: _sectionAnchors,
                    topInset: snapInset,
                    parent: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                  ),
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    overscroll: false,
                  ),
                  slivers: [
                    // ── Hero ─────────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: KeyedSubtree(
                        key: _heroKey,
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
                    ),

                    // ── Categories ────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: KeyedSubtree(
                        key: _categoriesKey,
                        child: _ScrollSectionReveal(
                          scrollNotifier: _scrollNotifier,
                          delay: const Duration(milliseconds: 40),
                          fromOffset: const Offset(-0.18, 0),
                          child: _SectionTitle(
                            overline: 'BROWSE BY',
                            title: 'Categories',
                            accent: AppColors.champagne,
                            r: r,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _ScrollSectionReveal(
                        scrollNotifier: _scrollNotifier,
                        delay: const Duration(milliseconds: 90),
                        fromOffset: const Offset(-0.16, 0),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: compactSectionGap),
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
                      child: KeyedSubtree(
                        key: _hotDealsKey,
                        child: _ScrollSectionReveal(
                          scrollNotifier: _scrollNotifier,
                          delay: const Duration(milliseconds: 50),
                          fromOffset: const Offset(0.18, 0),
                          child: _SectionTitle(
                            overline: "TODAY'S PICKS",
                            title: 'Hot Deals',
                            accent: AppColors.rose,
                            r: r,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: sectionGap),
                        child: _HotDealsRow(
                          products: state.hotDeals,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Flash Sale ────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: KeyedSubtree(
                        key: _flashSaleKey,
                        child: _ScrollSectionReveal(
                          scrollNotifier: _scrollNotifier,
                          delay: const Duration(milliseconds: 40),
                          fromOffset: const Offset(0, 0.12),
                          child: _SectionTitle(
                            overline: '⚡ LIMITED TIME',
                            title: 'Flash Sale',
                            accent: AppColors.roseDeep,
                            r: r,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _ScrollSectionReveal(
                        scrollNotifier: _scrollNotifier,
                        delay: const Duration(milliseconds: 90),
                        fromOffset: const Offset(0, 0.14),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: sectionGap),
                          child: FlashSaleSection(
                            items: state.flashSaleItems,
                            onAddToCart: cubit.addToCart,
                          ),
                        ),
                      ),
                    ),

                    // ── Featured ──────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: KeyedSubtree(
                        key: _featuredKey,
                        child: _ScrollSectionReveal(
                          scrollNotifier: _scrollNotifier,
                          delay: const Duration(milliseconds: 40),
                          fromOffset: const Offset(-0.14, 0),
                          child: _SectionTitle(
                            overline: 'EDITORIAL',
                            title: 'Featured',
                            accent: AppColors.champagne,
                            r: r,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _ScrollSectionReveal(
                        scrollNotifier: _scrollNotifier,
                        delay: const Duration(milliseconds: 95),
                        fromOffset: const Offset(-0.16, 0),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: sectionGap),
                          child: FeaturedCollection(
                            scrollNotifier: _scrollNotifier,
                          ),
                        ),
                      ),
                    ),

                    // ── Trending ──────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: KeyedSubtree(
                        key: _trendingKey,
                        child: _ScrollSectionReveal(
                          scrollNotifier: _scrollNotifier,
                          delay: const Duration(milliseconds: 45),
                          fromOffset: const Offset(0, 0),
                          child: _SectionTitle(
                            overline: 'POPULAR NOW',
                            title: 'Trending',
                            accent: AppColors.ice,
                            r: r,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: sectionGap),
                        child: TrendingSection(
                          products: state.trending,
                          scrollNotifier: _scrollNotifier,
                          onAddToCart: cubit.addToCart,
                        ),
                      ),
                    ),

                    // ── Brand Ticker ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: KeyedSubtree(
                        key: _brandsKey,
                        child: _ScrollSectionReveal(
                          scrollNotifier: _scrollNotifier,
                          delay: const Duration(milliseconds: 50),
                          fromOffset: const Offset(0, 0.12),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: sectionGap),
                            child: BrandTicker(
                              brands: state.brands,
                              scrollNotifier: _scrollNotifier,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: r.h(80))),
                  ],
                ),

          bottomNavigationBar: _Entrance(
            animation: _anim[2],
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

class _ScrollSectionReveal extends StatelessWidget {
  final ValueNotifier<double> scrollNotifier;
  final Duration delay;
  final Offset fromOffset;
  final Widget child;

  const _ScrollSectionReveal({
    required this.scrollNotifier,
    required this.delay,
    required this.fromOffset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      scrollNotifier: scrollNotifier,
      delay: delay,
      duration: const Duration(milliseconds: 760),
      fromOffset: fromOffset,
      fromScale: 0.978,
      fromBlur: 0,
      fromAngle: 0,
      triggerFraction: 0.95,
      parallaxExtent: 24,
      parallaxScale: 0.018,
      minVisibleOpacity: 0.52,
      exitDriftFactor: 0.48,
      useViewportOffset: true,
      child: child,
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

  const _SectionTitle({
    required this.overline,
    required this.title,
    required this.accent,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.w(20), r.h(10), r.w(20), r.h(12)),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            width: r.w(84),
            height: r.h(44),
            child: SparkleLayer(
              color: accent.withValues(alpha: 0.9),
              seed: title.hashCode,
              count: 4,
              maxSize: 5,
              minOpacity: 0.012,
              maxOpacity: 0.06,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: r.w(20),
                    height: r.h(2.2),
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
                      fontSize: r.sp(10.2),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.9,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'See All',
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: r.sp(12.2),
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
                ],
              ),
              SizedBox(height: r.h(5)),
              Text(
                title,
                style: AppTextStyles.displayL.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: r.sp(28.5),
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
            child: ScrollReveal(
              scrollNotifier: widget.scrollNotifier,
              delay: Duration(milliseconds: 42 * i),
              duration: const Duration(milliseconds: 580),
              fromOffset: Offset(i.isEven ? 14 : 18, 8),
              fromScale: 0.98,
              fromBlur: 0,
              triggerFraction: 0.98,
              parallaxExtent: 8,
              parallaxScale: 0.012,
              minVisibleOpacity: 0.8,
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
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
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
      builder: (context, child) => SingleChildScrollView(
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
