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
  late final Animation<double> _scale;
  late final Animation<double> _heartAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _heart = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scale = Tween(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
    _heartAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.88), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _heart, curve: Curves.easeOut));
  }

  @override
  void dispose() { _press.dispose(); _heart.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final p = widget.product;
    final w = widget.width ?? r.w(170);
    final accent = p.accentColor;

    Widget card = ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) { _press.forward(); setState(() => _hovered = true); },
        onTapUp: (_) { _press.reverse(); setState(() => _hovered = false); widget.onTap?.call(); },
        onTapCancel: () { _press.reverse(); setState(() => _hovered = false); },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: w,
          // NO explicit height — let parent (Grid or ListView) constrain it
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(r.r(20)),
            border: Border.all(
              color: _hovered ? accent.withOpacity(0.3) : AppColors.divider,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovered ? 0.10 : 0.05),
                blurRadius: _hovered ? 20 : 10,
                offset: const Offset(0, 4),
              ),
              if (_hovered)
                BoxShadow(
                  color: accent.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,  // fill parent height
            children: [
              // Image — Expanded to fill remaining space
              Expanded(
                child: _ProductImg(
                  product: p, r: r,
                  heartAnim: _heartAnim,
                  onFavorite: () {
                    HapticFeedback.lightImpact();
                    _heart.forward(from: 0);
                    widget.onFavorite?.call();
                  },
                ),
              ),

              // Details — fixed-height
              _ProductDetails(
                product: p, r: r, accent: accent,
                onAddToCart: () {
                  HapticFeedback.lightImpact();
                  widget.onAddToCart?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.scrollNotifier != null) {
      card = ScrollTilt3D(scrollNotifier: widget.scrollNotifier!, intensity: 0.5, child: card);
    }
    return card;
  }
}

// ── Product image section ──────────────────────────────────────────────────

class _ProductImg extends StatelessWidget {
  final Product product;
  final R r;
  final Animation<double> heartAnim;
  final VoidCallback onFavorite;

  const _ProductImg({
    required this.product, required this.r,
    required this.heartAnim, required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final accent = product.accentColor;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(r.r(20)),
        topRight: Radius.circular(r.r(20)),
      ),
      child: Stack(
        fit: StackFit.expand,   // fills whatever Expanded gives it
        children: [
          // Warm ivory photo background
          Container(color: AppColors.cardElevated),

          // Product photo — contain (shows full product on ivory bg)
          if (product.hasImage)
            Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, prog) {
                if (prog == null) return child;
                return _EmojiPlaceholder(product: product, r: r);
              },
              errorBuilder: (_, __, ___) =>
                  _EmojiPlaceholder(product: product, r: r),
            )
          else
            _EmojiPlaceholder(product: product, r: r),

          // Very subtle accent tint at top
          Positioned(
            top: 0, left: 0, right: 0,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accent.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Badge
          if (product.badge.isNotEmpty)
            Positioned(
              top: r.h(10), left: r.w(10),
              child: _Badge(label: product.badge, accent: accent, r: r),
            ),

          // Discount chip
          if (product.hasDiscount)
            Positioned(
              bottom: r.h(10), left: r.w(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: r.w(6), vertical: r.h(3)),
                decoration: BoxDecoration(
                  color: AppColors.rose,
                  borderRadius: BorderRadius.circular(r.r(6)),
                ),
                child: Text(
                  '-${product.discountPercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

          // Favorite button
          Positioned(
            top: r.h(8), right: r.w(8),
            child: GestureDetector(
              onTap: onFavorite,
              child: Container(
                width: r.w(32), height: r.w(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ScaleTransition(
                  scale: heartAnim,
                  child: Icon(
                    product.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: product.isFavorite ? AppColors.rose : AppColors.textMuted,
                    size: r.sp(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Product details section ────────────────────────────────────────────────

class _ProductDetails extends StatelessWidget {
  final Product product;
  final R r;
  final Color accent;
  final VoidCallback onAddToCart;

  const _ProductDetails({
    required this.product, required this.r,
    required this.accent, required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Container(
      padding: EdgeInsets.fromLTRB(r.w(12), r.h(10), r.w(10), r.h(10)),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand
          Text(
            p.brand.toUpperCase(),
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: r.sp(9),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: r.h(2)),

          // Name
          Text(
            p.name,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.sp(13),
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: r.h(5)),

          // Rating
          Row(
            children: [
              Icon(Icons.star_rounded, color: AppColors.champagne, size: r.sp(12)),
              SizedBox(width: r.w(2)),
              Text(
                p.rating.toStringAsFixed(1),
                style: TextStyle(
                  color: AppColors.champagne,
                  fontSize: r.sp(11),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: r.w(3)),
              Text(
                '(${_fmt(p.reviews)})',
                style: TextStyle(color: AppColors.textMuted, fontSize: r.sp(10)),
              ),
            ],
          ),
          SizedBox(height: r.h(8)),

          // Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (b) => AppColors.goldGradient.createShader(b),
                blendMode: BlendMode.srcIn,
                child: Text(
                  '\$${p.price.toInt()}',
                  style: TextStyle(
                    fontSize: r.sp(16),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              if (p.hasDiscount) ...[
                SizedBox(width: r.w(5)),
                Text(
                  '\$${p.originalPrice.toInt()}',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: r.sp(11),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const Spacer(),
              _AddBtn(accent: accent, r: r, onTap: onAddToCart),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

// ── Emoji placeholder ──────────────────────────────────────────────────────

class _EmojiPlaceholder extends StatelessWidget {
  final Product product;
  final R r;
  const _EmojiPlaceholder({required this.product, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardElevated,
      child: Center(
        child: Text(product.emoji, style: TextStyle(fontSize: r.sp(52))),
      ),
    );
  }
}

// ── Badge ──────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color accent;
  final R r;
  const _Badge({required this.label, required this.accent, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.w(7), vertical: r.h(3)),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(r.r(6)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Add to cart button ─────────────────────────────────────────────────────

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
          width: r.w(32), height: r.w(32),
          decoration: BoxDecoration(
            color: widget.accent,
            borderRadius: BorderRadius.circular(r.r(9)),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withOpacity(0.25),
                blurRadius: 8, offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 17),
        ),
      ),
    );
  }
}
