import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';

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

    _autoPlay =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 5000),
          )
          ..addStatusListener((s) {
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
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _autoPlay,
                builder: (_, __) => LinearProgressIndicator(
                  value: _autoPlay.value,
                  backgroundColor: AppColors.divider.withOpacity(0.55),
                  valueColor: AlwaysStoppedAnimation(
                    (widget.slides[_page]['accent'] as Color).withOpacity(0.70),
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
                      color: active
                          ? accent
                          : AppColors.textMuted.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: accent.withOpacity(0.18),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
              ),
            ),

            // Fade into page background
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: r.h(88),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.bg.withOpacity(0.92),
                    ],
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
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
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
        // 1 — Light premium base
        DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.heroGradient),
        ),

        // 2 — Background photo, softly washed into the layout
        Transform.translate(
          offset: Offset(0, scroll * 0.18),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.58),
            colorBlendMode: BlendMode.screen,
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
                colors: [accent.withOpacity(0.10), Colors.transparent],
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.10),
                  const Color(0xFFF8F6F2).withOpacity(0.88),
                ],
              ),
            ),
          ),
        ),

        // 5 — Floating product showcase
        Positioned(
          top: r.h(84),
          right: r.w(10),
          width: r.w(174),
          height: r.h(204),
          child: AnimatedBuilder(
            animation: Listenable.merge([widget.float, _enter]),
            builder: (_, __) {
              final floatT = widget.float.value;
              final dy = math.sin(floatT * math.pi * 2) * 10.0;
              final dx = math.cos(floatT * math.pi * 2) * 3.0;
              final enterT = CurvedAnimation(
                parent: _enter,
                curve: Curves.easeOutExpo,
              ).value.clamp(0.0, 1.0);

              return Transform.translate(
                offset: Offset(dx, dy + (1.0 - enterT) * 70),
                child: Opacity(
                  opacity: enterT,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: r.w(182),
                        height: r.w(182),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accent.withOpacity(0.10),
                              accent.withOpacity(0.03),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      _FloatingProductFrame(
                        r: r,
                        accent: accent,
                        imageUrl: productUrl,
                        emoji: emoji,
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
          right: r.w(132),
          child: AnimatedBuilder(
            animation: _enter,
            builder: (_, __) {
              final t = CurvedAnimation(
                parent: _enter,
                curve: Curves.easeOutCubic,
              ).value.clamp(0.0, 1.0);

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
                        r: r,
                      ),
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
                        maxLines: 2,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: r.sp(42),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.6,
                          height: 1.0,
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
                          color: AppColors.textSecondary,
                          fontSize: r.sp(12),
                          fontWeight: FontWeight.w400,
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
                          Flexible(
                            flex: 6,
                            child: _CtaButton(
                              label: d['cta'] as String,
                              accent: accent,
                              r: r,
                            ),
                          ),
                          SizedBox(width: r.w(10)),
                          Flexible(flex: 4, child: _GhostButton(r: r)),
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

class _FloatingProductFrame extends StatelessWidget {
  final R r;
  final Color accent;
  final String imageUrl;
  final String emoji;

  const _FloatingProductFrame({
    required this.r,
    required this.accent,
    required this.imageUrl,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: r.w(164),
      height: r.h(184),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: r.h(14),
            left: r.w(12),
            right: r.w(12),
            bottom: r.h(8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r.r(30)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.35),
                    Colors.white.withOpacity(0.12),
                  ],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.55)),
              ),
            ),
          ),
          Container(
            width: r.w(146),
            height: r.h(166),
            padding: EdgeInsets.fromLTRB(r.w(12), r.h(12), r.w(12), r.h(10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.r(28)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFFCF8).withOpacity(0.98),
                  const Color(0xFFF4EEE6).withOpacity(0.96),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.75),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                  spreadRadius: -8,
                ),
                BoxShadow(
                  color: accent.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                  spreadRadius: -8,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.w(10),
                          vertical: r.h(5),
                        ),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(r.r(20)),
                        ),
                        child: Text(
                          'CURATED',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: r.sp(9),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.diamond_outlined,
                        color: accent.withOpacity(0.55),
                        size: r.sp(16),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  top: r.h(22),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(r.r(20)),
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 0.95,
                        colors: [
                          accent.withOpacity(0.09),
                          const Color(0xFFFBF7F1),
                          const Color(0xFFF0E8DD),
                        ],
                        stops: const [0.0, 0.52, 1.0],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(r.w(10)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (_, child, prog) => prog == null
                            ? child
                            : Center(
                                child: Text(
                                  emoji,
                                  style: TextStyle(fontSize: r.sp(52)),
                                ),
                              ),
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: r.sp(52)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        color: accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(r.r(20)),
        border: Border.all(color: accent.withOpacity(0.22), width: 1),
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
                BoxShadow(color: accent.withOpacity(0.35), blurRadius: 6),
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
  const _CtaButton({
    required this.label,
    required this.accent,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
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
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: r.w(18), vertical: r.h(13)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(r.r(40)),
        border: Border.all(color: AppColors.divider.withOpacity(0.9), width: 1),
      ),
      child: Text(
        'Wishlist',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: r.sp(13),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
