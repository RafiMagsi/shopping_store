import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import 'scroll_tilt.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToCart;
  final double? width;
  final ValueNotifier<double>? scrollNotifier;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap, this.onFavorite, this.onAddToCart,
    this.width, this.scrollNotifier,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with TickerProviderStateMixin {
  late final AnimationController _press;
  late final AnimationController _heart;
  late final AnimationController _gloss;
  late final Animation<double> _scale;
  late final Animation<double> _heartAnim;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _heart = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _gloss = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
    _scale = Tween(begin: 1.0, end: 0.93)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
    _heartAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.6), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.6, end: 0.85), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _heart, curve: Curves.easeOut));
  }

  @override
  void dispose() { _press.dispose(); _heart.dispose(); _gloss.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final p = widget.product;
    final w = widget.width ?? r.w(170);
    final accent = p.accentColor;

    Widget card = ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _press.forward(),
        onTapUp: (_) { _press.reverse(); widget.onTap?.call(); },
        onTapCancel: () => _press.reverse(),
        child: Container(
          width: w,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(r.r(22)),
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 24, offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: accent.withOpacity(0.12),
                blurRadius: 32, offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              _ProductImg(
                product: p, r: r,
                glossAnim: _gloss,
                heartAnim: _heartAnim,
                onFavorite: () {
                  HapticFeedback.lightImpact();
                  _heart.forward(from: 0);
                  widget.onFavorite?.call();
                },
              ),
              // Details
              Padding(
                padding: EdgeInsets.fromLTRB(r.w(12), r.h(10), r.w(12), r.h(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.brand.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: r.sp(9),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        )),
                    SizedBox(height: r.h(3)),
                    Text(p.name,
                        style: AppTextStyles.h3.copyWith(fontSize: r.sp(13)),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: r.h(6)),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: AppColors.amber, size: r.sp(12)),
                        SizedBox(width: r.w(2)),
                        Text(p.rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: AppColors.amber,
                              fontSize: r.sp(11),
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(width: r.w(4)),
                        Text('(${_fmt(p.reviews)})',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: r.sp(10))),
                      ],
                    ),
                    SizedBox(height: r.h(8)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShaderMask(
                          shaderCallback: (b) => AppColors.goldGradient.createShader(b),
                          blendMode: BlendMode.srcIn,
                          child: Text('\$${p.price.toInt()}',
                              style: TextStyle(fontSize: r.sp(17), fontWeight: FontWeight.w800)),
                        ),
                        if (p.hasDiscount) ...[
                          SizedBox(width: r.w(5)),
                          Text('\$${p.originalPrice.toInt()}',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: r.sp(11),
                                decoration: TextDecoration.lineThrough,
                              )),
                        ],
                        const Spacer(),
                        _AddBtn(accent: accent, r: r, onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onAddToCart?.call();
                        }),
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

    if (widget.scrollNotifier != null) {
      card = ScrollTilt3D(scrollNotifier: widget.scrollNotifier!, intensity: 0.7, child: card);
    }
    return card;
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

class _ProductImg extends StatelessWidget {
  final Product product;
  final R r;
  final AnimationController glossAnim;
  final Animation<double> heartAnim;
  final VoidCallback onFavorite;

  const _ProductImg({
    required this.product, required this.r,
    required this.glossAnim, required this.heartAnim,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final accent = product.accentColor;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(r.r(22)),
        topRight: Radius.circular(r.r(22)),
      ),
      child: SizedBox(
        height: r.h(160),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Product photo
            product.hasImage
                ? Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, p) => p == null
                        ? child
                        : _GradientPlaceholder(product: product, r: r),
                    errorBuilder: (_, __, ___) =>
                        _GradientPlaceholder(product: product, r: r),
                  )
                : _GradientPlaceholder(product: product, r: r),

            // Gradient overlay (bottom dark + top color tint)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      accent.withOpacity(0.08),
                      AppColors.card.withOpacity(0.7),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),

            // Sweeping gloss
            AnimatedBuilder(
              animation: glossAnim,
              builder: (_, __) => Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (b) => LinearGradient(
                    begin: Alignment(glossAnim.value * 3 - 2.5, -0.5),
                    end: Alignment(glossAnim.value * 3 - 1.5, 0.5),
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ).createShader(b),
                  blendMode: BlendMode.srcATop,
                  child: Container(color: Colors.white),
                ),
              ),
            ),

            // Neon glow border at bottom
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, accent, Colors.transparent],
                  ),
                  boxShadow: [
                    BoxShadow(color: accent.withOpacity(0.6), blurRadius: 8),
                  ],
                ),
              ),
            ),

            // Badge
            if (product.badge.isNotEmpty)
              Positioned(
                top: r.h(10), left: r.w(10),
                child: _Badge(label: product.badge, accent: accent, r: r),
              ),

            // Discount
            if (product.hasDiscount)
              Positioned(
                bottom: r.h(10), left: r.w(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r.r(6)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: r.w(7), vertical: r.h(3)),
                      color: AppColors.pink.withOpacity(0.85),
                      child: Text('-${product.discountPercent.toInt()}%',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ),

            // Favorite
            Positioned(
              top: r.h(8), right: r.w(8),
              child: GestureDetector(
                onTap: onFavorite,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: r.w(34), height: r.w(34),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: ScaleTransition(
                        scale: heartAnim,
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: product.isFavorite ? AppColors.pink : Colors.white70,
                          size: r.sp(16),
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
    );
  }
}

class _GradientPlaceholder extends StatelessWidget {
  final Product product;
  final R r;
  const _GradientPlaceholder({required this.product, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [product.gradientStart, product.gradientEnd],
        ),
      ),
      child: Center(child: Text(product.emoji, style: TextStyle(fontSize: r.sp(60)))),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color accent;
  final R r;
  const _Badge({required this.label, required this.accent, required this.r});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r.r(6)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: r.w(8), vertical: r.h(3)),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(r.r(6)),
            border: Border.all(color: accent.withOpacity(0.5), width: 1),
          ),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        ),
      ),
    );
  }
}

class _AddBtn extends StatefulWidget {
  final Color accent;
  final R r;
  final VoidCallback onTap;
  const _AddBtn({required this.accent, required this.r, required this.onTap});

  @override
  State<_AddBtn> createState() => _AddBtnState();
}

class _AddBtnState extends State<_AddBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) { _c.reverse(); widget.onTap(); },
      onTapCancel: () => _c.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.82).animate(_c),
        child: Container(
          width: r.w(34), height: r.w(34),
          decoration: BoxDecoration(
            color: widget.accent,
            borderRadius: BorderRadius.circular(r.r(10)),
            boxShadow: [
              BoxShadow(color: widget.accent.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
