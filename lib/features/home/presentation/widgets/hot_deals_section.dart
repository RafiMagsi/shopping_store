import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import 'scroll_reveal.dart';
import 'scroll_tilt.dart';

class HotDealsSection extends StatefulWidget {
  final List<Product> products;
  final ValueNotifier<double> scrollNotifier;
  final VoidCallback onAddToCart;

  const HotDealsSection({
    super.key,
    required this.products,
    required this.scrollNotifier,
    required this.onAddToCart,
  });

  @override
  State<HotDealsSection> createState() => _HotDealsSectionState();
}

class _HotDealsSectionState extends State<HotDealsSection> {
  final _hScroll = ScrollController();
  final _hNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _hScroll.addListener(() => _hNotifier.value = _hScroll.offset);
  }

  @override
  void dispose() {
    _hScroll.dispose();
    _hNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SizedBox(
      height: r.h(310),
      child: ListView.builder(
        controller: _hScroll,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: r.w(16)),
        itemCount: widget.products.length,
        itemBuilder: (_, i) {
          final p = widget.products[i];
          return Padding(
            padding: EdgeInsets.only(right: r.w(14)),
            child: HorizontalTilt3D(
              scrollNotifier: _hNotifier,
              child: ScrollReveal(
                scrollNotifier: widget.scrollNotifier,
                delay: Duration(milliseconds: 80 * i),
                fromOffset: const Offset(30, 0),
                use3d: false,
                child: _DealCard(
                  product: p,
                  r: r,
                  onAddToCart: widget.onAddToCart,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DealCard extends StatefulWidget {
  final Product product;
  final R r;
  final VoidCallback onAddToCart;

  const _DealCard({required this.product, required this.r, required this.onAddToCart});

  @override
  State<_DealCard> createState() => _DealCardState();
}

class _DealCardState extends State<_DealCard> with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  void dispose() { _press.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final p = widget.product;
    final accent = p.accentColor;

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 0.95).animate(_press),
      child: GestureDetector(
        onTapDown: (_) => _press.forward(),
        onTapUp: (_) => _press.reverse(),
        onTapCancel: () => _press.reverse(),
        child: Container(
          width: r.w(200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.r(24)),
            border: Border.all(color: AppColors.divider, width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, offset: const Offset(0, 12)),
              BoxShadow(color: accent.withOpacity(0.18), blurRadius: 40, offset: const Offset(0, 20)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r.r(24)),
            child: Stack(
              children: [
                // Full-bleed product image
                Positioned.fill(
                  child: p.hasImage
                      ? Image.network(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallback(p, r),
                          loadingBuilder: (_, child, prog) =>
                              prog == null ? child : _fallback(p, r),
                        )
                      : _fallback(p, r),
                ),

                // Dark gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                // Neon glow line at top
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, accent, Colors.transparent],
                      ),
                      boxShadow: [BoxShadow(color: accent.withOpacity(0.8), blurRadius: 12)],
                    ),
                  ),
                ),

                // Badge top-left
                if (p.badge.isNotEmpty)
                  Positioned(
                    top: r.h(12), left: r.w(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: r.w(10), vertical: r.h(4)),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(r.r(8)),
                        boxShadow: [BoxShadow(color: accent.withOpacity(0.5), blurRadius: 10)],
                      ),
                      child: Text(p.badge,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 1)),
                    ),
                  ),

                // Content at bottom
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(r.w(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(p.brand.toUpperCase(),
                            style: TextStyle(
                              color: accent,
                              fontSize: r.sp(9),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            )),
                        SizedBox(height: r.h(2)),
                        Text(p.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: r.h(8)),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('\$${p.price.toInt()}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: r.sp(20),
                                      fontWeight: FontWeight.w800,
                                    )),
                                if (p.hasDiscount)
                                  Text('\$${p.originalPrice.toInt()}',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: r.sp(11),
                                        decoration: TextDecoration.lineThrough,
                                      )),
                              ],
                            ),
                            const Spacer(),
                            // Add to cart
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                widget.onAddToCart();
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                  child: Container(
                                    width: r.w(42), height: r.w(42),
                                    decoration: BoxDecoration(
                                      color: accent.withOpacity(0.25),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: accent.withOpacity(0.6), width: 1.5),
                                    ),
                                    child: Icon(Icons.add_rounded, color: accent, size: r.sp(20)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fallback(Product p, R r) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [p.gradientStart, p.gradientEnd],
      ),
    ),
    child: Center(child: Text(p.emoji, style: TextStyle(fontSize: r.sp(80)))),
  );
}
