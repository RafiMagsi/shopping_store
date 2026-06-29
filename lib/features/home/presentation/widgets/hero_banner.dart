import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';

// ── Film grain overlay ─────────────────────────────────────────────────────
class _GrainPainter extends CustomPainter {
  final int seed;
  const _GrainPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed * 31 + 7);
    final paint = Paint()..color = Colors.white.withOpacity(0.017);
    for (int i = 0; i < 1800; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        rng.nextDouble() * 0.9,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GrainPainter old) => old.seed != seed;
}

// ── Hero Banner ────────────────────────────────────────────────────────────
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
  late final AnimationController _float;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();

    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();

    _autoPlay = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) {
          final next = (_page + 1) % widget.slides.length;
          _pageCtrl.animateToPage(
            next,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOutCubic,
          );
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
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final scroll = widget.scrollOffset;
    final bannerH = r.h(620);
    final fadeT = (scroll / 260).clamp(0.0, 1.0);

    return SizedBox(
      height: bannerH,
      child: Opacity(
        opacity: (1.0 - fadeT * 0.55).clamp(0.0, 1.0),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageCtrl,
              itemCount: widget.slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => _HeroSlide(
                data: widget.slides[i],
                scrollOffset: scroll,
                float: _float,
                isActive: i == _page,
                slideIndex: i,
                r: r,
              ),
            ),

            // Slide progress bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: AnimatedBuilder(
                animation: _autoPlay,
                builder: (_, __) => LinearProgressIndicator(
                  value: _autoPlay.value,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation(
                    (widget.slides[_page]['accent'] as Color).withOpacity(0.65),
                  ),
                  minHeight: 2,
                ),
              ),
            ),

            // Page dots
            Positioned(
              bottom: r.h(28),
              left: r.w(24),
              child: Row(
                children: List.generate(widget.slides.length, (i) {
                  final active = i == _page;
                  final accent = widget.slides[_page]['accent'] as Color;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(right: r.w(6)),
                    width: active ? r.w(28) : r.w(5),
                    height: r.h(5),
                    decoration: BoxDecoration(
                      color: active ? accent : Colors.white.withOpacity(0.28),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: active
                          ? [BoxShadow(color: accent.withOpacity(0.7), blurRadius: 12)]
                          : null,
                    ),
                  );
                }),
              ),
            ),

            // Fade into page background
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: r.h(120),
                decoration: const BoxDecoration(
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

// ── Individual Slide ───────────────────────────────────────────────────────
class _HeroSlide extends StatefulWidget {
  final Map<String, dynamic> data;
  final double scrollOffset;
  final AnimationController float;
  final bool isActive;
  final int slideIndex;
  final R r;

  const _HeroSlide({
    required this.data,
    required this.scrollOffset,
    required this.float,
    required this.isActive,
    required this.slideIndex,
    required this.r,
  });

  @override
  State<_HeroSlide> createState() => _HeroSlideState();
}

class _HeroSlideState extends State<_HeroSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    if (widget.isActive) _enter.forward();
  }

  @override
  void didUpdateWidget(_HeroSlide old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) _enter.forward(from: 0);
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
    final productUrl = d['productUrl'] as String? ?? imageUrl;
    final emoji = d['emoji'] as String? ?? '✨';
    final scroll = widget.scrollOffset;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1 — Deep cinematic base
        const ColoredBox(color: Color(0xFF0C0A08)),

        // 2 — Background fashion photo, barely visible (texture only)
        Transform.translate(
          offset: Offset(0, scroll * 0.18),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.80),
            colorBlendMode: BlendMode.darken,
            loadingBuilder: (_, child, prog) =>
                prog == null ? child : const SizedBox(),
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),

        // 3 — Accent color atmospheric wash (bottom-left corner)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-1.0, 0.9),
                radius: 1.1,
                colors: [
                  accent.withOpacity(0.20),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 4 — Film grain
        Positioned.fill(
          child: CustomPaint(painter: _GrainPainter(widget.slideIndex)),
        ),

        // 5 — Floating product (upper zone, vertically centered-top)
        Positioned(
          top: r.h(55),
          left: 0,
          right: 0,
          height: r.h(310),
          child: AnimatedBuilder(
            animation: Listenable.merge([widget.float, _enter]),
            builder: (_, __) {
              final floatT = widget.float.value;
              final dy = math.sin(floatT * math.pi * 2) * 14.0;
              final dx = math.cos(floatT * math.pi * 2) * 4.5;
              final enterT = CurvedAnimation(
                      parent: _enter, curve: Curves.easeOutExpo)
                  .value
                  .clamp(0.0, 1.0);

              return Transform.translate(
                offset: Offset(dx, dy + (1.0 - enterT) * 55),
                child: Opacity(
                  opacity: enterT,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer atmospheric halo (wide, soft)
                      Container(
                        width: r.w(300),
                        height: r.w(300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accent.withOpacity(0.38),
                              accent.withOpacity(0.12),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Inner bright core glow
                      Container(
                        width: r.w(160),
                        height: r.w(160),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accent.withOpacity(0.30),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                      // Product image — white-bg removed, edge-faded
                      SizedBox(
                        width: r.w(250),
                        height: r.h(290),
                        child: ShaderMask(
                          // Soft radial edge fade → atmospheric floating feel
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (rect) => const RadialGradient(
                            center: Alignment.center,
                            radius: 0.88,
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.68, 1.0],
                          ).createShader(rect),
                          child: ColorFiltered(
                            // Luminosity → alpha:
                            // white (luma=1) → alpha=0 (transparent)
                            // black (luma=0) → alpha=1 (opaque)
                            // colored → partial alpha (glowing effect)
                            colorFilter: const ColorFilter.matrix([
                              1, 0, 0, 0, 0,
                              0, 1, 0, 0, 0,
                              0, 0, 1, 0, 0,
                              -0.2126, -0.7152, -0.0722, 0, 255,
                            ]),
                            child: Image.network(
                              productUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (_, child, prog) => prog == null
                                  ? child
                                  : Center(
                                      child: Text(emoji,
                                          style: TextStyle(
                                              fontSize: r.sp(80)))),
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(emoji,
                                    style: TextStyle(fontSize: r.sp(80))),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Drop shadow ellipse below product
                      Positioned(
                        bottom: r.h(8),
                        child: Container(
                          width: r.w(130),
                          height: r.h(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.35),
                                blurRadius: 28,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // 6 — Editorial text content (bottom zone)
        Positioned(
          bottom: r.h(65),
          left: r.w(24),
          right: r.w(24),
          child: AnimatedBuilder(
            animation: _enter,
            builder: (_, __) {
              final t = CurvedAnimation(
                      parent: _enter, curve: Curves.easeOutCubic)
                  .value
                  .clamp(0.0, 1.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tag pill
                  Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(-24 * (1 - t), 0),
                      child: _TagPill(
                          label: d['tag'] as String,
                          accent: accent,
                          r: r),
                    ),
                  ),

                  SizedBox(height: r.h(14)),

                  // Oversized editorial headline
                  Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 34 * (1 - t)),
                      child: Text(
                        d['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: r.sp(50),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2.5,
                          height: 0.93,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(11)),

                  // Subtitle
                  Opacity(
                    opacity: (t * 0.65).clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - t)),
                      child: Text(
                        d['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: r.sp(13),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.3,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(22)),

                  // CTA buttons
                  Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 16 * (1 - t)),
                      child: Row(
                        children: [
                          _CtaButton(
                            label: d['cta'] as String,
                            accent: accent,
                            r: r,
                          ),
                          SizedBox(width: r.w(10)),
                          _GhostButton(r: r),
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

// ── Tag Pill ───────────────────────────────────────────────────────────────
class _TagPill extends StatelessWidget {
  final String label;
  final Color accent;
  final R r;
  const _TagPill({required this.label, required this.accent, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.w(11), vertical: r.h(5)),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(r.r(20)),
        border: Border.all(color: accent.withOpacity(0.40), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: r.w(5),
            height: r.w(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent,
              boxShadow: [
                BoxShadow(color: accent.withOpacity(0.9), blurRadius: 6)
              ],
            ),
          ),
          SizedBox(width: r.w(7)),
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: r.sp(10),
              fontWeight: FontWeight.w800,
              letterSpacing: 2.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Primary CTA ────────────────────────────────────────────────────────────
class _CtaButton extends StatelessWidget {
  final String label;
  final Color accent;
  final R r;
  const _CtaButton(
      {required this.label, required this.accent, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.w(24), vertical: r.h(13)),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(r.r(40)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.50),
            blurRadius: 22,
            offset: const Offset(0, 7),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: r.sp(13),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Ghost / Wishlist button ────────────────────────────────────────────────
class _GhostButton extends StatelessWidget {
  final R r;
  const _GhostButton({required this.r});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r.r(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: r.w(18), vertical: r.h(13)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(r.r(40)),
            border:
                Border.all(color: Colors.white.withOpacity(0.18), width: 1),
          ),
          child: Text(
            'Wishlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: r.sp(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
