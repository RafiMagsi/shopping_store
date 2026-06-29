import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import 'scroll_reveal.dart';

class FeaturedCollection extends StatelessWidget {
  final ValueNotifier<double> scrollNotifier;

  const FeaturedCollection({super.key, required this.scrollNotifier});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return ScrollReveal(
      scrollNotifier: scrollNotifier,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FEATURED',
              style: AppTextStyles.overline.copyWith(fontSize: r.sp(11)),
            ),
            SizedBox(height: r.h(8)),
            Text(
              'New Season\nCollection',
              style: AppTextStyles.displayM.copyWith(fontSize: r.sp(32)),
            ),
            SizedBox(height: r.h(20)),

            // Feature cards row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ScrollReveal(
                    scrollNotifier: scrollNotifier,
                    delay: const Duration(milliseconds: 100),
                    fromOffset: const Offset(-40, 0),
                    child: _BigFeatureCard(r: r),
                  ),
                ),
                SizedBox(width: r.w(12)),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ScrollReveal(
                        scrollNotifier: scrollNotifier,
                        delay: const Duration(milliseconds: 200),
                        fromOffset: const Offset(40, 0),
                        child: _SmallFeatureCard(
                          r: r,
                          emoji: '👜',
                          label: 'Bags',
                          color: const Color(0xFF2E2218),
                          gradientEnd: const Color(0xFF4A3020),
                        ),
                      ),
                      SizedBox(height: r.h(12)),
                      ScrollReveal(
                        scrollNotifier: scrollNotifier,
                        delay: const Duration(milliseconds: 300),
                        fromOffset: const Offset(40, 0),
                        child: _SmallFeatureCard(
                          r: r,
                          emoji: '⌚',
                          label: 'Watches',
                          color: const Color(0xFF1A1A2E),
                          gradientEnd: const Color(0xFF2D2D6B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BigFeatureCard extends StatelessWidget {
  final R r;
  const _BigFeatureCard({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: r.h(260),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E2A1E), Color(0xFF0A180A)],
        ),
        borderRadius: BorderRadius.circular(r.r(20)),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Stack(
        children: [
          // Subtle orb
          Positioned(
            top: -r.h(20),
            right: -r.w(20),
            child: Container(
              width: r.w(120),
              height: r.w(120),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald.withOpacity(0.1),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(r.w(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.w(8), vertical: r.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(r.r(6)),
                  ),
                  child: Text(
                    'NEW IN',
                    style: AppTextStyles.labelS.copyWith(
                      color: AppColors.emerald, fontSize: r.sp(9),
                    ),
                  ),
                ),
                const Spacer(),
                Text('👟', style: TextStyle(fontSize: r.sp(60))),
                SizedBox(height: r.h(8)),
                Text(
                  'Nike Air\nMax 2025',
                  style: AppTextStyles.h2.copyWith(fontSize: r.sp(18)),
                ),
                SizedBox(height: r.h(4)),
                Text(
                  'Starting from \$199',
                  style: AppTextStyles.bodyS.copyWith(
                    color: AppColors.amber, fontSize: r.sp(11),
                  ),
                ),
                SizedBox(height: r.h(12)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.w(14), vertical: r.h(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(r.r(10)),
                  ),
                  child: Text(
                    'Shop Now →',
                    style: AppTextStyles.labelL.copyWith(
                      color: Colors.white, fontSize: r.sp(12),
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

class _SmallFeatureCard extends StatelessWidget {
  final R r;
  final String emoji;
  final String label;
  final Color color;
  final Color gradientEnd;

  const _SmallFeatureCard({
    required this.r,
    required this.emoji,
    required this.label,
    required this.color,
    required this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: r.h(124),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, gradientEnd],
        ),
        borderRadius: BorderRadius.circular(r.r(16)),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(r.w(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(emoji, style: TextStyle(fontSize: r.sp(34))),
                SizedBox(height: r.h(4)),
                Text(
                  label,
                  style: AppTextStyles.h3.copyWith(fontSize: r.sp(13)),
                ),
              ],
            ),
          ),
          Positioned(
            top: r.h(8),
            right: r.w(8),
            child: Icon(Icons.arrow_outward_rounded,
                color: Colors.white.withOpacity(0.4), size: r.sp(16)),
          ),
        ],
      ),
    );
  }
}
