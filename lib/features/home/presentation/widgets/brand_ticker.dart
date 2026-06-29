import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import 'scroll_reveal.dart';

class BrandTicker extends StatefulWidget {
  final List<String> brands;
  final ValueNotifier<double> scrollNotifier;

  const BrandTicker({
    super.key,
    required this.brands,
    required this.scrollNotifier,
  });

  @override
  State<BrandTicker> createState() => _BrandTickerState();
}

class _BrandTickerState extends State<BrandTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scroll;
  late final ScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = ScrollController();
    _scroll = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _scroll.addListener(() {
      if (!_ctrl.hasClients) return;
      final maxScroll = _ctrl.position.maxScrollExtent;
      if (maxScroll <= 0) return;
      final target = _scroll.value * maxScroll;
      _ctrl.jumpTo(target % maxScroll);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final repeated = [...widget.brands, ...widget.brands, ...widget.brands];

    return ScrollReveal(
      scrollNotifier: widget.scrollNotifier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OUR BRANDS',
                  style: AppTextStyles.overline.copyWith(fontSize: r.sp(11)),
                ),
                SizedBox(height: r.h(4)),
                Text(
                  'Trusted Partners',
                  style: AppTextStyles.h1.copyWith(fontSize: r.sp(22)),
                ),
              ],
            ),
          ),
          SizedBox(height: r.h(20)),

          // Fade edges + ticker
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppColors.bg,
                Colors.transparent,
                Colors.transparent,
                AppColors.bg,
              ],
              stops: [0.0, 0.1, 0.9, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.dstOut,
            child: SizedBox(
              height: r.h(56),
              child: ListView.builder(
                controller: _ctrl,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: r.w(20)),
                itemCount: repeated.length,
                itemBuilder: (_, i) => _BrandChip(
                  brand: repeated[i],
                  r: r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String brand;
  final R r;

  const _BrandChip({required this.brand, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: r.w(16)),
      padding: EdgeInsets.symmetric(horizontal: r.w(20), vertical: r.h(14)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(r.r(12)),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Text(
        brand,
        style: AppTextStyles.labelL.copyWith(
          color: AppColors.textSecondary,
          fontSize: r.sp(13),
          letterSpacing: 2,
        ),
      ),
    );
  }
}
