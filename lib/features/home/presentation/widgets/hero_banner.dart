import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

class HeroBanner extends StatefulWidget {
  final double scrollOffset;
  final double scrollVelocity;
  final List<Map<String, dynamic>> slides;

  const HeroBanner({
    super.key,
    required this.scrollOffset,
    required this.slides,
    this.scrollVelocity = 0,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> with TickerProviderStateMixin {
  late final PageController _pageCtrl;
  late final AnimationController _autoPlay;
  late final AnimationController _shimmer;
  late final AnimationController _pulse;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(viewportFraction: 1.0);
    _shimmer = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    // Auto-advance every 4s
    _autoPlay = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) {
          final next = (_page + 1) % widget.slides.length;
          _pageCtrl.animateToPage(next,
              duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic);
          _autoPlay.reset();
          _autoPlay.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _autoPlay.dispose();
    _shimmer.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final scroll = widget.scrollOffset;
    final bannerH = r.h(600);

    // Fade banner on scroll
    final fadeT = (scroll / 220).clamp(0.0, 1.0);

    return SizedBox(
      height: bannerH,
      child: Opacity(
        opacity: (1 - fadeT * 0.5).clamp(0.0, 1.0),
        child: Stack(
          children: [
            // ── PageView of slides ──────────────────────────────────
            PageView.builder(
              controller: _pageCtrl,
              itemCount: widget.slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => _HeroSlide(
                data: widget.slides[i],
                scrollOffset: scroll,
                shimmer: _shimmer,
                pulse: _pulse,
                isActive: i == _page,
                r: r,
              ),
            ),

            // ── Page indicators ─────────────────────────────────────
            Positioned(
              bottom: r.h(32),
              left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.slides.length, (i) {
                  final active = i == _page;
                  final accent = widget.slides[_page]['accent'] as Color;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(horizontal: r.w(3)),
                    width: active ? r.w(24) : r.w(6),
                    height: r.h(6),
                    decoration: BoxDecoration(
                      color: active ? accent : Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: active ? [
                        BoxShadow(color: accent.withOpacity(0.6), blurRadius: 8),
                      ] : null,
                    ),
                  );
                }),
              ),
            ),

            // ── Bottom gradient ──────────────────────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: r.h(160),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.bg],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSlide extends StatefulWidget {
  final Map<String, dynamic> data;
  final double scrollOffset;
  final AnimationController shimmer;
  final AnimationController pulse;
  final bool isActive;
  final R r;

  const _HeroSlide({
    required this.data,
    required this.scrollOffset,
    required this.shimmer,
    required this.pulse,
    required this.isActive,
    required this.r,
  });

  @override
  State<_HeroSlide> createState() => _HeroSlideState();
}

class _HeroSlideState extends State<_HeroSlide> with SingleTickerProviderStateMixin {
  late final AnimationController _enter;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    if (widget.isActive) _enter.forward();
  }

  @override
  void didUpdateWidget(_HeroSlide old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _enter.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final d = widget.data;
    final accent = d['accent'] as Color;
    final imageUrl = d['imageUrl'] as String;
    final scroll = widget.scrollOffset;

    return Stack(
      children: [
        // ── Full-bleed background photo with parallax ───────────────
        Positioned.fill(
          child: Transform.translate(
            offset: Offset(0, scroll * 0.35),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.surface, accent.withOpacity(0.15)],
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.surface, accent.withOpacity(0.3)],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Dark overlay gradient ────────────────────────────────────
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.6),
                  AppColors.bg.withOpacity(0.95),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // ── Left accent glow ────────────────────────────────────────
        Positioned(
          left: -r.w(60),
          bottom: r.h(80),
          child: AnimatedBuilder(
            animation: widget.pulse,
            builder: (_, __) => Container(
              width: r.w(200),
              height: r.w(200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withOpacity(0.25 + widget.pulse.value * 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Text content ─────────────────────────────────────────────
        Positioned(
          bottom: r.h(90),
          left: r.w(24),
          right: r.w(24),
          child: AnimatedBuilder(
            animation: _enter,
            builder: (_, __) {
              final t = CurvedAnimation(parent: _enter, curve: Curves.easeOutCubic).value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag pill
                  Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(-20 * (1 - t), 0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: r.w(12), vertical: r.h(5)),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(r.r(20)),
                          border: Border.all(color: accent.withOpacity(0.5), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: widget.pulse,
                              builder: (_, __) => Container(
                                width: r.w(6), height: r.w(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accent,
                                  boxShadow: [BoxShadow(
                                    color: accent.withOpacity(0.8 + widget.pulse.value * 0.2),
                                    blurRadius: 6,
                                  )],
                                ),
                              ),
                            ),
                            SizedBox(width: r.w(7)),
                            Text(
                              d['tag'] as String,
                              style: TextStyle(
                                color: accent,
                                fontSize: r.sp(10),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(16)),

                  // Headline
                  Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - t)),
                      child: Text(
                        d['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: r.sp(46),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2.5,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(10)),

                  // Subtitle
                  Opacity(
                    opacity: t * 0.8,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - t)),
                      child: Text(
                        d['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: r.sp(15),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(28)),

                  // CTA row
                  Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 15 * (1 - t)),
                      child: Row(
                        children: [
                          // Primary button with shimmer
                          AnimatedBuilder(
                            animation: widget.shimmer,
                            builder: (_, child) => ShaderMask(
                              shaderCallback: (b) => LinearGradient(
                                begin: Alignment(widget.shimmer.value * 3 - 2, 0),
                                end: Alignment(widget.shimmer.value * 3, 0),
                                colors: [
                                  accent,
                                  Color.lerp(accent, Colors.white, 0.5)!,
                                  accent,
                                ],
                              ).createShader(b),
                              child: child!,
                            ),
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: r.w(26), vertical: r.h(15)),
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(r.r(40)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accent.withOpacity(0.5),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                      spreadRadius: -4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  d['cta'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: r.sp(14),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: r.w(14)),

                          // Ghost button
                          ClipRRect(
                            borderRadius: BorderRadius.circular(r.r(40)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: r.w(20), vertical: r.h(15)),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(r.r(40)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.2), width: 1),
                                ),
                                child: Text(
                                  'Wishlist',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: r.sp(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
