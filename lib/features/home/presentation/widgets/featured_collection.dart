import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import 'scroll_reveal.dart';

// Product images for the featured section
class _FeaturedImg {
  static const sneaker =
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop&q=80';
  static const bag =
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&h=400&fit=crop&q=80';
  static const watch =
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop&q=80';
}

class FeaturedCollection extends StatelessWidget {
  final ValueNotifier<double> scrollNotifier;

  const FeaturedCollection({super.key, required this.scrollNotifier});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.w(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big editorial dark card (left, flex 3)
          Expanded(
            flex: 3,
            child: ScrollReveal(
              scrollNotifier: scrollNotifier,
              delay: const Duration(milliseconds: 80),
              fromOffset: const Offset(-24, 0),
              parallaxExtent: 40,
              parallaxScale: 0.032,
              minVisibleOpacity: 0.42,
              exitDriftFactor: 0.7,
              child: _BigEditorialCard(r: r),
            ),
          ),

          SizedBox(width: r.w(12)),

          // Right column — two equal small cards
          SizedBox(
            width: r.w(130),
            height: r.h(260),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollReveal(
                    scrollNotifier: scrollNotifier,
                    delay: const Duration(milliseconds: 180),
                    fromOffset: const Offset(20, 0),
                    parallaxExtent: 22,
                    parallaxScale: 0.02,
                    minVisibleOpacity: 0.54,
                    exitDriftFactor: 0.6,
                    child: _SmallCard(
                      r: r,
                      imageUrl: _FeaturedImg.bag,
                      emoji: '👜',
                      label: 'Bags',
                      bg: const Color(0xFFF5EFE5),
                      bgEnd: const Color(0xFFEDE6D8),
                      accent: AppColors.champagne,
                    ),
                  ),
                ),
                SizedBox(height: r.h(12)),
                Expanded(
                  child: ScrollReveal(
                    scrollNotifier: scrollNotifier,
                    delay: const Duration(milliseconds: 260),
                    fromOffset: const Offset(20, 0),
                    parallaxExtent: 22,
                    parallaxScale: 0.02,
                    minVisibleOpacity: 0.54,
                    exitDriftFactor: 0.6,
                    child: _SmallCard(
                      r: r,
                      imageUrl: _FeaturedImg.watch,
                      emoji: '⌚',
                      label: 'Watches',
                      bg: const Color(0xFFEBF0F5),
                      bgEnd: const Color(0xFFDDE6EF),
                      accent: AppColors.ice,
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

// ── Big editorial feature card ─────────────────────────────────────────────
class _BigEditorialCard extends StatefulWidget {
  final R r;
  const _BigEditorialCard({required this.r});

  @override
  State<_BigEditorialCard> createState() => _BigEditorialCardState();
}

class _BigEditorialCardState extends State<_BigEditorialCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;

    return Container(
      height: r.h(260),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFFFFBF6), const Color(0xFFF2EBE2)],
        ),
        borderRadius: BorderRadius.circular(r.r(20)),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Atmospheric glow — top right
          Positioned(
            top: -r.h(20),
            right: -r.w(20),
            child: Container(
              width: r.w(140),
              height: r.w(140),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.champagne.withOpacity(0.09),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Floating product image (right side)
          Positioned(
            right: r.w(10),
            top: r.h(18),
            width: r.w(120),
            height: r.h(156),
            child: AnimatedBuilder(
              animation: _float,
              builder: (_, child) {
                final dy = math.sin(_float.value * math.pi * 2) * 6.0;
                return Transform.translate(offset: Offset(0, dy), child: child);
              },
              child: _FramedProductVisual(
                r: r,
                accent: AppColors.champagne,
                imageUrl: _FeaturedImg.sneaker,
                emoji: '👟',
                compact: false,
              ),
            ),
          ),

          // Text content (left/bottom)
          Padding(
            padding: EdgeInsets.all(r.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NEW IN badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.w(8),
                    vertical: r.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.champagne.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(r.r(6)),
                    border: Border.all(
                      color: AppColors.champagne.withOpacity(0.18),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'NEW IN',
                    style: TextStyle(
                      color: AppColors.champagneDeep,
                      fontSize: r.sp(9),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                const Spacer(),

                // Title
                Text(
                  'Nike Air\nMax 2025',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.sp(18),
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: r.h(4)),

                // Price
                ShaderMask(
                  shaderCallback: (b) => AppColors.goldGradient.createShader(b),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'From \$199',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.sp(12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: r.h(12)),

                // Shop Now button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.w(14),
                    vertical: r.h(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.champagneDeep,
                    borderRadius: BorderRadius.circular(r.r(10)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.champagne.withOpacity(0.14),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Shop Now →',
                    style: AppTextStyles.labelL.copyWith(
                      color: Colors.white,
                      fontSize: r.sp(11),
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

// ── Small category card ────────────────────────────────────────────────────
class _SmallCard extends StatelessWidget {
  final R r;
  final String imageUrl;
  final String emoji;
  final String label;
  final Color bg;
  final Color bgEnd;
  final Color accent;

  const _SmallCard({
    required this.r,
    required this.imageUrl,
    required this.emoji,
    required this.label,
    required this.bg,
    required this.bgEnd,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg, bgEnd],
        ),
        borderRadius: BorderRadius.circular(r.r(16)),
        border: Border.all(color: accent.withOpacity(0.20), width: 1),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Product image framed as a premium object
          Positioned(
            right: r.w(8),
            top: r.h(10),
            width: r.w(72),
            height: r.h(74),
            child: _FramedProductVisual(
              r: r,
              accent: accent,
              imageUrl: imageUrl,
              emoji: emoji,
              compact: true,
            ),
          ),

          // Text (bottom left)
          Positioned(
            left: r.w(12),
            bottom: r.h(12),
            right: r.w(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: r.sp(14),
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: r.h(2)),
                Row(
                  children: [
                    Text(
                      'Shop',
                      style: TextStyle(
                        color: accent,
                        fontSize: r.sp(10),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: r.w(2)),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: accent,
                      size: r.sp(10),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Top-right arrow icon
          Positioned(
            top: r.h(8),
            right: r.w(8),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(0.10),
              ),
              child: Icon(
                Icons.arrow_outward_rounded,
                color: accent,
                size: r.sp(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FramedProductVisual extends StatelessWidget {
  final R r;
  final Color accent;
  final String imageUrl;
  final String emoji;
  final bool compact;

  const _FramedProductVisual({
    required this.r,
    required this.accent,
    required this.imageUrl,
    required this.emoji,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final radius = compact ? r.r(18) : r.r(26);
    final padding = compact ? r.w(7) : r.w(12);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(compact ? 0.90 : 0.95),
            const Color(0xFFF0E7D9).withOpacity(compact ? 0.92 : 0.96),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.75), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(compact ? 0.10 : 0.16),
            blurRadius: compact ? 14 : 22,
            offset: const Offset(0, 8),
            spreadRadius: compact ? -8 : -10,
          ),
          BoxShadow(
            color: accent.withOpacity(compact ? 0.16 : 0.22),
            blurRadius: compact ? 18 : 24,
            offset: const Offset(0, 6),
            spreadRadius: compact ? -10 : -12,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(compact ? r.r(14) : r.r(20)),
          gradient: RadialGradient(
            center: const Alignment(0, -0.1),
            radius: 0.95,
            colors: [
              accent.withOpacity(compact ? 0.12 : 0.16),
              const Color(0xFFF6F1E8),
              const Color(0xFFE9DFD0),
            ],
            stops: const [0.0, 0.52, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(compact ? r.w(6) : r.w(10)),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: r.sp(compact ? 24 : 44)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
