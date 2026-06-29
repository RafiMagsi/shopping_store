import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

// Brand data: name + Clearbit logo URL
class _Brand {
  final String name;
  final String logoUrl;
  const _Brand(this.name, this.logoUrl);
}

const _brands = [
  _Brand('Gucci', 'https://logo.clearbit.com/gucci.com'),
  _Brand('Rolex', 'https://logo.clearbit.com/rolex.com'),
  _Brand('Prada', 'https://logo.clearbit.com/prada.com'),
  _Brand('Hermès', 'https://logo.clearbit.com/hermes.com'),
  _Brand('Louis Vuitton', 'https://logo.clearbit.com/louisvuitton.com'),
  _Brand('Chanel', 'https://logo.clearbit.com/chanel.com'),
  _Brand('Dior', 'https://logo.clearbit.com/dior.com'),
  _Brand('Versace', 'https://logo.clearbit.com/versace.com'),
];

class BrandTicker extends StatefulWidget {
  final List<String>
  brands; // kept for API compat; ignored — uses _brands above
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
  late final AnimationController _ctrl;

  // Width of one full set of brand chips (calculated after first frame)
  // We use a fixed chip width so we can compute the loop point ahead of time.
  static const double _chipWidth = 140.0; // px per chip (name + padding)
  static const double _chipGap = 16.0;
  static const double _tileWidth = _chipWidth + _chipGap;
  static const int _count = 8; // must match _brands.length
  static const double _totalW = _tileWidth * _count;

  // Duration so full loop takes ~18 s regardless of count
  static const Duration _loopDuration = Duration(seconds: 18);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _loopDuration)..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    // Section-level animation handled by page-entrance system in home_page.dart
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Padding(
          padding: EdgeInsets.fromLTRB(r.w(20), 0, r.w(20), r.h(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRUSTED LABELS',
                style: AppTextStyles.labelS.copyWith(
                  color: AppColors.champagne,
                  fontSize: r.sp(9.5),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: r.h(2)),
              Text(
                'Verified Brand Partners',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: r.sp(20),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),

        // Smooth ticker — fades at edges
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.bg,
              Colors.transparent,
              Colors.transparent,
              AppColors.bg,
            ],
            stops: [0.0, 0.08, 0.92, 1.0],
          ).createShader(bounds),
          blendMode: BlendMode.dstOut,
          child: SizedBox(
            height: r.h(68),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) {
                // Smooth translate: moves -_totalW over the full duration, then loops
                final offset = -_ctrl.value * _totalW;
                return OverflowBox(
                  alignment: Alignment.centerLeft,
                  maxWidth: double.infinity,
                  child: Transform.translate(
                    offset: Offset(offset, 0),
                    child: Row(
                      children: [
                        // Triple the brands so seam is always off-screen
                        for (int rep = 0; rep < 3; rep++)
                          for (final brand in _brands)
                            _BrandChip(brand: brand, r: r),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandChip extends StatelessWidget {
  final _Brand brand;
  final R r;
  const _BrandChip({required this.brand, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _BrandTickerState._chipWidth,
      margin: const EdgeInsets.only(right: _BrandTickerState._chipGap),
      padding: EdgeInsets.symmetric(horizontal: r.w(12), vertical: r.h(10)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.r(18)),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo image
          ClipRRect(
            borderRadius: BorderRadius.circular(r.r(8)),
            child: Container(
              width: r.w(30),
              height: r.w(30),
              padding: EdgeInsets.all(r.w(4)),
              decoration: BoxDecoration(
                color: AppColors.cardElevated,
                borderRadius: BorderRadius.circular(r.r(8)),
              ),
              child: Image.network(
                brand.logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    _FallbackLogo(brand: brand, r: r),
              ),
            ),
          ),
          SizedBox(width: r.w(8)),
          Flexible(
            child: Text(
              brand.name,
              style: AppTextStyles.labelL.copyWith(
                color: AppColors.textSecondary,
                fontSize: r.sp(12),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  final _Brand brand;
  final R r;
  const _FallbackLogo({required this.brand, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: r.w(24),
      height: r.w(24),
      decoration: BoxDecoration(
        color: AppColors.champagneMuted,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          brand.name[0],
          style: AppTextStyles.labelM.copyWith(
            color: AppColors.champagne,
            fontSize: r.sp(11),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
