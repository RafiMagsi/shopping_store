import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import 'sparkle_layer.dart';

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
    final bannerH = r.h(592);
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
                scrollVelocity: widget.scrollVelocity,
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
                builder: (context, child) => LinearProgressIndicator(
                  value: _autoPlay.value,
                  backgroundColor: AppColors.divider.withValues(alpha: 0.46),
                  valueColor: AlwaysStoppedAnimation(
                    (widget.slides[_page]['accent'] as Color).withValues(
                      alpha: 0.62,
                    ),
                  ),
                  minHeight: 2,
                ),
              ),
            ),

            // Page dots
            Positioned(
              bottom: r.h(26),
              left: r.w(24),
              child: Row(
                children: List.generate(widget.slides.length, (i) {
                  final active = i == _page;
                  final accent = widget.slides[_page]['accent'] as Color;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(right: r.w(6)),
                    width: active ? r.w(24) : r.w(6),
                    height: r.h(4),
                    decoration: BoxDecoration(
                      color: active
                          ? accent
                          : AppColors.textMuted.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.18),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
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
  final double scrollVelocity;
  final AnimationController float;
  final bool isActive;
  final int slideIndex;
  final R r;

  const _HeroSlide({
    required this.data,
    required this.scrollOffset,
    required this.scrollVelocity,
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
    final xParallax =
        (-widget.scrollOffset * 0.035 - widget.scrollVelocity * 2.0).clamp(
          -24.0,
          24.0,
        ) +
        math.sin((widget.scrollOffset * 0.01) + widget.slideIndex) * 4.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1 — Light premium base
        DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.heroGradient),
        ),

        // 2 — Background photo, softly washed into the layout
        Transform.translate(
          offset: Offset(xParallax, scroll * 0.18),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            color: Colors.white.withValues(alpha: 0.52),
            colorBlendMode: BlendMode.screen,
            loadingBuilder: (context, child, prog) =>
                prog == null ? child : const SizedBox(),
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        ),

        // 3 — Accent color atmospheric wash (bottom-left corner)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-1.0, 0.9),
                radius: 1.1,
                colors: [accent.withValues(alpha: 0.08), Colors.transparent],
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: SparkleLayer(
            color: accent.withValues(alpha: 0.9),
            seed: widget.slideIndex + 11,
            count: 8,
            maxSize: 8,
            minOpacity: 0.015,
            maxOpacity: 0.08,
          ),
        ),

        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  const Color(0xFFF7F4EE).withValues(alpha: 0.90),
                ],
              ),
            ),
          ),
        ),

        // 5 — Floating product showcase
        Positioned(
          top: r.h(96),
          right: r.w(14),
          width: r.w(162),
          height: r.h(188),
          child: AnimatedBuilder(
            animation: Listenable.merge([widget.float, _enter]),
            builder: (context, child) {
              final floatT = widget.float.value;
              final dy = math.sin(floatT * math.pi * 2) * 7.0;
              final dx = math.cos(floatT * math.pi * 2) * 2.0;
              final enterT = CurvedAnimation(
                parent: _enter,
                curve: Curves.easeOutExpo,
              ).value.clamp(0.0, 1.0);

              return Transform.translate(
                offset: Offset(dx, dy + (1.0 - enterT) * 54),
                child: Opacity(
                  opacity: enterT,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: r.w(164),
                        height: r.w(164),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accent.withValues(alpha: 0.10),
                              accent.withValues(alpha: 0.025),
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
                      Positioned.fill(
                        child: SparkleLayer(
                          color: accent.withValues(alpha: 0.9),
                          seed: widget.slideIndex + 41,
                          count: 5,
                          maxSize: 6,
                          minOpacity: 0.02,
                          maxOpacity: 0.09,
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
          bottom: r.h(52),
          left: r.w(30),
          right: r.w(34),
          child: AnimatedBuilder(
            animation: _enter,
            builder: (context, child) {
              final t = CurvedAnimation(
                parent: _enter,
                curve: Curves.easeOutCubic,
              ).value.clamp(0.0, 1.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity: (t * 0.85).clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, 10 * (1 - t)),
                            child: Text(
                              'New season picks · Curated for you',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelL.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: r.sp(11.2),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.h(8)),

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

                  SizedBox(height: r.h(12)),

                  // Commerce-first headline
                  Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - t)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: r.w(228)),
                        child: Text(
                          d['title'] as String,
                          maxLines: 2,
                          style: AppTextStyles.displayXL.copyWith(
                            fontSize: r.sp(35.5),
                            color: AppColors.textPrimary,
                            height: 1.04,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(10)),

                  // Subtitle
                  Opacity(
                    opacity: (t * 0.78).clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - t)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: r.w(232)),
                        child: Text(
                          d['subtitle'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyL.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: r.sp(13.0),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(12)),

                  Opacity(
                    opacity: (t * 0.72).clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 16 * (1 - t)),
                      child: Wrap(
                        spacing: r.w(8),
                        runSpacing: r.h(8),
                        children: const [
                          _HeroInfoChip(label: 'Free delivery'),
                          _HeroInfoChip(label: 'Easy returns'),
                          _HeroInfoChip(label: 'Top rated'),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(16)),

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
                          Flexible(
                            flex: 4,
                            child: _GhostButton(r: r, label: 'Save'),
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
      width: r.w(154),
      height: r.h(172),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: r.h(10),
            left: r.w(10),
            right: r.w(10),
            bottom: r.h(6),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r.r(28)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.34),
                    Colors.white.withValues(alpha: 0.12),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.50)),
              ),
            ),
          ),
          Container(
            width: r.w(144),
            height: r.h(160),
            padding: EdgeInsets.fromLTRB(r.w(10), r.h(10), r.w(10), r.h(8)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.r(28)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFFBF6).withValues(alpha: 0.98),
                  const Color(0xFFF3ECE3).withValues(alpha: 0.96),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.68),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                  spreadRadius: -8,
                ),
                BoxShadow(
                  color: accent.withValues(alpha: 0.045),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                          color: accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(r.r(20)),
                        ),
                        child: Text(
                          'CURATED',
                          style: AppTextStyles.labelM.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: r.sp(9),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.diamond_outlined,
                        color: accent.withValues(alpha: 0.42),
                        size: r.sp(16),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  top: r.h(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(r.r(22)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.frameSurface,
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.15),
                          radius: 0.98,
                          colors: [
                            accent.withValues(alpha: 0.06),
                            AppColors.frameSurface,
                            AppColors.cardElevated,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.55),
                          width: 0.8,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          r.w(6),
                          r.h(8),
                          r.w(6),
                          r.h(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(r.r(18)),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, prog) =>
                                prog == null
                                ? child
                                : Center(
                                    child: Text(
                                      emoji,
                                      style: TextStyle(fontSize: r.sp(52)),
                                    ),
                                  ),
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Text(
                                    emoji,
                                    style: TextStyle(fontSize: r.sp(52)),
                                  ),
                                ),
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
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(r.r(20)),
        border: Border.all(color: accent.withValues(alpha: 0.22), width: 1),
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
                BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 6),
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
        borderRadius: BorderRadius.circular(r.r(22)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.34),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: AppTextStyles.buttonL.copyWith(
          color: Colors.white,
          fontSize: r.sp(13.5),
        ),
      ),
    );
  }
}

// ── Ghost / Wishlist button ────────────────────────────────────────────────
class _GhostButton extends StatelessWidget {
  final R r;
  final String label;
  const _GhostButton({required this.r, this.label = 'Wishlist'});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: r.w(18), vertical: r.h(13)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(r.r(22)),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.9),
          width: 1,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: AppTextStyles.buttonL.copyWith(
          color: AppColors.textPrimary,
          fontSize: r.sp(13.2),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeroInfoChip extends StatelessWidget {
  final String label;

  const _HeroInfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.w(9), vertical: r.h(5)),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(r.r(999)),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.85),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelM.copyWith(
          color: AppColors.textSecondary,
          fontSize: r.sp(10),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
