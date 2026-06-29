import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

class AppHeader extends StatefulWidget {
  final double scrollOffset;
  final int cartCount;
  final VoidCallback? onSearch;
  final VoidCallback? onCart;
  final VoidCallback? onProfile;

  const AppHeader({
    super.key,
    required this.scrollOffset,
    required this.cartCount,
    this.onSearch,
    this.onCart,
    this.onProfile,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cartBounce;

  @override
  void initState() {
    super.initState();
    _cartBounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(AppHeader old) {
    super.didUpdateWidget(old);
    if (old.cartCount != widget.cartCount) {
      _cartBounce.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _cartBounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final scrolled = widget.scrollOffset > 10;
    final opacity = (widget.scrollOffset / 80).clamp(0.0, 1.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(scrolled ? opacity * 0.96 : 0),
          border: scrolled
              ? Border(
                  bottom: BorderSide(color: AppColors.divider, width: opacity),
                )
              : null,
        ),
        child: scrolled
            ? ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20 * opacity,
                    sigmaY: 20 * opacity,
                  ),
                  child: _HeaderContent(
                    r: r,
                    cartCount: widget.cartCount,
                    cartBounce: _cartBounce,
                    onSearch: widget.onSearch,
                    onCart: widget.onCart,
                    onProfile: widget.onProfile,
                    scrolled: scrolled,
                    titleOpacity: opacity,
                  ),
                ),
              )
            : _HeaderContent(
                r: r,
                cartCount: widget.cartCount,
                cartBounce: _cartBounce,
                onSearch: widget.onSearch,
                onCart: widget.onCart,
                onProfile: widget.onProfile,
                scrolled: scrolled,
                titleOpacity: opacity,
              ),
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  final R r;
  final int cartCount;
  final AnimationController cartBounce;
  final VoidCallback? onSearch;
  final VoidCallback? onCart;
  final VoidCallback? onProfile;
  final bool scrolled;
  final double titleOpacity;

  const _HeaderContent({
    required this.r,
    required this.cartCount,
    required this.cartBounce,
    required this.scrolled,
    required this.titleOpacity,
    this.onSearch,
    this.onCart,
    this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.w(20), vertical: r.h(12)),
        child: Row(
          children: [
            // Logo / Brand
            AnimatedOpacity(
              opacity: scrolled ? titleOpacity : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Container(
                    width: r.w(38),
                    height: r.w(38),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(r.r(14)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.champagne.withOpacity(0.14),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'L',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: r.w(8)),
                  Text(
                    'LUXE',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: r.sp(17.5),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.6,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Search
            _IconBtn(
              icon: Icons.search_rounded,
              onTap: onSearch ?? () {},
              r: r,
            ),
            SizedBox(width: r.w(4)),

            // Cart with badge
            _CartBtn(
              count: cartCount,
              bounce: cartBounce,
              onTap: onCart ?? () {},
              r: r,
            ),
            SizedBox(width: r.w(4)),

            // Profile
            _ProfileAvatar(r: r, onTap: onProfile ?? () {}),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final R r;

  const _IconBtn({required this.icon, required this.onTap, required this.r});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: r.w(40),
        height: r.w(40),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.98),
          borderRadius: BorderRadius.circular(r.r(14)),
          border: Border.all(color: AppColors.divider, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: r.sp(20)),
      ),
    );
  }
}

class _CartBtn extends StatelessWidget {
  final int count;
  final AnimationController bounce;
  final VoidCallback onTap;
  final R r;

  const _CartBtn({
    required this.count,
    required this.bounce,
    required this.onTap,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: r.w(40),
            height: r.w(40),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.98),
              borderRadius: BorderRadius.circular(r.r(12)),
              border: Border.all(color: AppColors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textPrimary,
              size: r.sp(20),
            ),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: AnimatedBuilder(
                animation: bounce,
                builder: (_, child) => Transform.scale(
                  scale: 1.0 + 0.3 * Curves.elasticOut.transform(bounce.value),
                  child: child,
                ),
                child: Container(
                  width: r.w(18),
                  height: r.w(18),
                  decoration: BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: r.sp(9),
                        fontWeight: FontWeight.w800,
                      ),
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

class _ProfileAvatar extends StatelessWidget {
  final R r;
  final VoidCallback onTap;

  const _ProfileAvatar({required this.r, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: r.w(40),
        height: r.w(40),
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.champagneDeep, width: 1.5),
        ),
        child: Center(
          child: Text(
            'R',
            style: TextStyle(
              color: AppColors.textInverse,
              fontSize: r.sp(15),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
