import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/category_item.dart';
import 'scroll_reveal.dart';

// ── Icon mapping — professional icon set ───────────────────────────────────
const _iconMap = <String, IconData>{
  'all': Icons.apps_rounded,
  'electronics': Icons.bolt_rounded,
  'fashion': Icons.checkroom_rounded,
  'beauty': Icons.spa_rounded,
  'sports': Icons.fitness_center_rounded,
  'home': Icons.weekend_rounded,
  'luxury': Icons.diamond_rounded,
};

// ── Gradient pairs per category ────────────────────────────────────────────
// Each pair: [lighter, deeper] used for the icon badge gradient
const _gradientMap = <String, List<Color>>{
  'all': [Color(0xFFD4B896), Color(0xFFB89070)],
  'electronics': [Color(0xFF7EC8F0), Color(0xFF3A90C8)],
  'fashion': [Color(0xFFF0A080), Color(0xFFD05830)],
  'beauty': [Color(0xFFDDA8D0), Color(0xFFB060A0)],
  'sports': [Color(0xFF80C8A0), Color(0xFF3A9060)],
  'home': [Color(0xFFD4B896), Color(0xFFB07050)],
  'luxury': [Color(0xFFE0C870), Color(0xFFB89030)],
};

class CategoryStrip extends StatefulWidget {
  final List<CategoryItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ValueNotifier<double> scrollNotifier;

  const CategoryStrip({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
    required this.scrollNotifier,
  });

  @override
  State<CategoryStrip> createState() => _CategoryStripState();
}

class _CategoryStripState extends State<CategoryStrip> {
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SizedBox(
      height: r.h(50),
      child: ListView.builder(
        controller: _scrollCtrl,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: r.w(18), vertical: r.h(6)),
        itemCount: widget.categories.length,
        itemBuilder: (_, i) {
          final item = widget.categories[i];
          final selected = i == widget.selectedIndex;
          return ScrollReveal(
            scrollNotifier: widget.scrollNotifier,
            delay: Duration(milliseconds: 35 * i),
            fromOffset: const Offset(0, 18),
            fromBlur: 0,
            child: _CategoryChip(
              item: item,
              isSelected: selected,
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onSelect(i);
              },
              r: r,
            ),
          );
        },
      ),
    );
  }
}

// ── Individual chip ────────────────────────────────────────────────────────
class _CategoryChip extends StatefulWidget {
  final CategoryItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final R r;

  const _CategoryChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.r,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 85),
    );
    _scale = Tween(
      begin: 1.0,
      end: 0.91,
    ).animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final item = widget.item;
    final selected = widget.isSelected;
    final gradients = _gradientMap[item.id] ?? [item.color, item.color];
    final icon = _iconMap[item.id] ?? Icons.circle_outlined;
    final baseColor = gradients[0];
    final deepColor = gradients[1];

    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) {
        _press.reverse();
        widget.onTap();
      },
      onTapCancel: () => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: EdgeInsets.only(right: r.w(8)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: r.w(10),
              vertical: r.h(5),
            ),
            decoration: BoxDecoration(
              color: selected ? deepColor.withOpacity(0.09) : AppColors.surface,
              borderRadius: BorderRadius.circular(r.r(18)),
              border: Border.all(
                color: selected
                    ? deepColor.withOpacity(0.35)
                    : AppColors.divider,
                width: 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: deepColor.withOpacity(0.20),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                        spreadRadius: -2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Gradient icon badge ──────────────────────────────
                _IconBadge(
                  icon: icon,
                  gradientTop: baseColor,
                  gradientBottom: deepColor,
                  isSelected: selected,
                  r: r,
                ),
                SizedBox(width: r.w(7)),
                // ── Label ────────────────────────────────────────────
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: AppTextStyles.labelL.copyWith(
                    color: selected ? deepColor : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: selected ? 0.1 : 0.0,
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Gradient icon badge ────────────────────────────────────────────────────
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color gradientTop;
  final Color gradientBottom;
  final bool isSelected;
  final R r;

  const _IconBadge({
    required this.icon,
    required this.gradientTop,
    required this.gradientBottom,
    required this.isSelected,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    final size = r.w(28);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [gradientTop, gradientBottom]
              : [
                  gradientTop.withOpacity(0.15),
                  gradientBottom.withOpacity(0.22),
                ],
        ),
        borderRadius: BorderRadius.circular(r.r(10)),
        border: Border.all(
          color: isSelected
              ? gradientTop.withOpacity(0.5)
              : gradientBottom.withOpacity(0.20),
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: gradientBottom.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                  spreadRadius: -2,
                ),
              ]
            : [],
      ),
      child: Center(
        child: Icon(
          icon,
          size: r.sp(14),
          color: isSelected ? Colors.white : gradientBottom.withOpacity(0.85),
        ),
      ),
    );
  }
}
