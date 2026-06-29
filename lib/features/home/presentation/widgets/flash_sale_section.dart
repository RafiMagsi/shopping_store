import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';

class FlashSaleSection extends StatefulWidget {
  final List<Product> items;
  final VoidCallback onAddToCart;

  const FlashSaleSection({
    super.key,
    required this.items,
    required this.onAddToCart,
  });

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _remaining = 3 * 3600 + 24 * 60 + 17; // 3h 24m 17s
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > 0 && mounted) {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final h = _remaining ~/ 3600;
    final m = (_remaining % 3600) ~/ 60;
    final s = _remaining % 60;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: r.w(20)),
      decoration: BoxDecoration(
        gradient: AppColors.flashGradient,
        borderRadius: BorderRadius.circular(r.r(28)),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(r.w(20), r.h(20), r.w(20), 0),
            child: Row(
              children: [
                // Pulsing bolt
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, child) => Transform.scale(
                    scale: 0.9 + 0.1 * _pulse.value,
                    child: child,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(r.w(8)),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(r.r(14)),
                      border: Border.all(color: AppColors.divider, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.bolt_rounded,
                      color: AppColors.rose,
                      size: r.sp(18),
                    ),
                  ),
                ),

                SizedBox(width: r.w(12)),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FLASH SALE',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.rose,
                        fontSize: r.sp(11),
                      ),
                    ),
                    Text(
                      'Ends soon · limited stock',
                      style: AppTextStyles.bodyS.copyWith(
                        fontSize: r.sp(11),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Countdown
                Row(
                  children: [
                    _FlipDigit(value: h, r: r),
                    _DigitSep(r: r),
                    _FlipDigit(value: m, r: r),
                    _DigitSep(r: r),
                    _FlipDigit(value: s, r: r),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: r.h(16)),

          // Items
          ...widget.items.map(
            (p) =>
                _FlashItem(product: p, r: r, onAddToCart: widget.onAddToCart),
          ),

          SizedBox(height: r.h(8)),
        ],
      ),
    );
  }
}

class _FlipDigit extends StatelessWidget {
  final int value;
  final R r;

  const _FlipDigit({required this.value, required this.r});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: Container(
        key: ValueKey(value),
        width: r.w(32),
        height: r.h(34),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(r.r(8)),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Center(
          child: Text(
            value.toString().padLeft(2, '0'),
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontSize: r.sp(16),
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _DigitSep extends StatelessWidget {
  final R r;
  const _DigitSep({required this.r});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: r.w(3)),
    child: Text(
      ':',
      style: AppTextStyles.h3.copyWith(
        color: AppColors.rose,
        fontSize: r.sp(18),
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _FlashItem extends StatefulWidget {
  final Product product;
  final R r;
  final VoidCallback onAddToCart;

  const _FlashItem({
    required this.product,
    required this.r,
    required this.onAddToCart,
  });

  @override
  State<_FlashItem> createState() => _FlashItemState();
}

class _FlashItemState extends State<_FlashItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _barCtrl;
  late final Animation<double> _bar;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bar = Tween<double>(
      begin: 0,
      end: widget.product.soldPercent / 100,
    ).animate(CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _barCtrl.forward();
    });
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final p = widget.product;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: r.w(12), vertical: r.h(6)),
      padding: EdgeInsets.all(r.w(12)),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(r.r(22)),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: r.w(68),
            height: r.h(68),
            padding: EdgeInsets.all(r.w(4)),
            decoration: BoxDecoration(
              color: AppColors.frameSurface,
              borderRadius: BorderRadius.circular(r.r(18)),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.72),
                width: 0.8,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(r.r(14)),
              child: SizedBox(
                width: r.w(60),
                height: r.h(60),
                child: p.hasImage
                    ? Image.network(
                        p.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [p.gradientStart, p.gradientEnd],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              p.emoji,
                              style: TextStyle(fontSize: r.sp(28)),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [p.gradientStart, p.gradientEnd],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            p.emoji,
                            style: TextStyle(fontSize: r.sp(28)),
                          ),
                        ),
                      ),
              ),
            ),
          ),

          SizedBox(width: r.w(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: r.sp(13.6),
                    fontWeight: FontWeight.w700,
                    height: 1.12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: r.h(1)),
                Text(
                  p.brand,
                  style: AppTextStyles.bodyS.copyWith(
                    color: AppColors.textMuted,
                    fontSize: r.sp(10.2),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: r.h(5)),
                Row(
                  children: [
                    Text(
                      '\$${p.price.toInt()}',
                      style: AppTextStyles.price.copyWith(fontSize: r.sp(15)),
                    ),
                    SizedBox(width: r.w(6)),
                    Text(
                      '\$${p.originalPrice.toInt()}',
                      style: AppTextStyles.priceStrike.copyWith(
                        fontSize: r.sp(11),
                      ),
                    ),
                    SizedBox(width: r.w(6)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.w(5),
                        vertical: r.h(2),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.roseDeep,
                        borderRadius: BorderRadius.circular(r.r(4)),
                      ),
                      child: Text(
                        '-${p.discountPercent.toInt()}%',
                        style: AppTextStyles.labelM.copyWith(
                          color: Colors.white,
                          fontSize: r.sp(9),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.h(6)),

                // Sold progress
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(r.r(4)),
                        child: SizedBox(
                          height: r.h(4),
                          child: AnimatedBuilder(
                            animation: _bar,
                            builder: (context, child) =>
                                LinearProgressIndicator(
                                  value: _bar.value,
                                  backgroundColor: AppColors.textMuted
                                      .withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.rose,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: r.w(8)),
                    Text(
                      '${p.soldPercent}% sold',
                      style: AppTextStyles.bodyS.copyWith(
                        color: AppColors.rose,
                        fontSize: r.sp(9.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: r.w(8)),

          // Add button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onAddToCart();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.w(14),
                vertical: r.h(10),
              ),
              decoration: BoxDecoration(
                color: AppColors.rose,
                borderRadius: BorderRadius.circular(r.r(14)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.rose.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Buy',
                style: AppTextStyles.labelL.copyWith(
                  color: AppColors.textInverse,
                  fontSize: r.sp(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
