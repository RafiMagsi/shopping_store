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
                // Right column: bounded SizedBox so Expanded children work
                SizedBox(
                  width: r.w(130),
                  height: r.h(260), // matches _BigFeatureCard height exactly
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ScrollReveal(
                          scrollNotifier: scrollNotifier,
                          delay: const Duration(milliseconds: 200),
                          fromOffset: const Offset(40, 0),
                          child: _SmallFeatureCard(
                            r: r,
                            emoji: '👜',
                            label: 'Bags',
                            color: const Color(0xFFF5EFE5),
                            gradientEnd: const Color(0xFFEDE6D8),
                            accent: Color(0xFF9A7B4F),
                          ),
                        ),
                      ),
                      SizedBox(height: r.h(12)),
                      Expanded(
                        child: ScrollReveal(
                          scrollNotifier: scrollNotifier,
                          delay: const Duration(milliseconds: 300),
                          fromOffset: const Offset(40, 0),
                          child: _SmallFeatureCard(
                            r: r,
                            emoji: '⌚',
                            label: 'Watches',
                            color: const Color(0xFFEBF0F5),
                            gradientEnd: const Color(0xFFDDE6EF),
                            accent: Color(0xFF3D5A80),
                          ),
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
          colors: [Color(0xFFF5F3EE), Color(0xFFEFEDE8)],
        ),
        borderRadius: BorderRadius.circular(r.r(20)),
        border: Border.all(color: AppColors.divider, width: 1),
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
                color: AppColors.sage.withOpacity(0.08),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(r.w(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.w(8), vertical: r.h(3),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sage.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(r.r(6)),
                  ),
                  child: Text(
                    'NEW IN',
                    style: AppTextStyles.labelS.copyWith(
                      color: AppColors.sage, fontSize: r.sp(9),
                    ),
                  ),
                ),
                const Spacer(),
                Text('👟', style: TextStyle(fontSize: r.sp(48))),
                SizedBox(height: r.h(6)),
                Text(
                  'Nike Air\nMax 2025',
                  style: AppTextStyles.h2.copyWith(fontSize: r.sp(16)),
                ),
                SizedBox(height: r.h(3)),
                Text(
                  'From \$199',
                  style: AppTextStyles.bodyS.copyWith(
                    color: AppColors.champagne, fontSize: r.sp(10),
                  ),
                ),
                SizedBox(height: r.h(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.w(12), vertical: r.h(7),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.champagne,
                    borderRadius: BorderRadius.circular(r.r(10)),
                  ),
                  child: Text(
                    'Shop Now →',
                    style: AppTextStyles.labelL.copyWith(
                      color: Colors.white, fontSize: r.sp(11),
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
  final Color accent;

  const _SmallFeatureCard({
    required this.r,
    required this.emoji,
    required this.label,
    required this.color,
    required this.gradientEnd,
    this.accent = AppColors.champagne,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      // No fixed height — fills Expanded parent for equal sizing
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, gradientEnd],
        ),
        borderRadius: BorderRadius.circular(r.r(16)),
        border: Border.all(color: accent.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(color: accent.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(r.w(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(emoji, style: TextStyle(fontSize: r.sp(30))),
                SizedBox(height: r.h(4)),
                Text(
                  label,
                  style: AppTextStyles.h3.copyWith(fontSize: r.sp(13), color: AppColors.textPrimary),
                ),
                SizedBox(height: r.h(2)),
                Text(
                  'Shop →',
                  style: AppTextStyles.labelS.copyWith(color: accent, fontSize: r.sp(9)),
                ),
              ],
            ),
          ),
          Positioned(
            top: r.h(8),
            right: r.w(8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(0.12),
              ),
              child: Icon(Icons.arrow_outward_rounded, color: accent, size: r.sp(12)),
            ),
          ),
        ],
      ),
    );
  }
}
