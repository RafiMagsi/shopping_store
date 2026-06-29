import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/category_item.dart';
import 'scroll_reveal.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.w(20)),
          child: ScrollReveal(
            scrollNotifier: widget.scrollNotifier,
            fromOffset: const Offset(-30, 0),
            child: Row(
              children: [
                Text('Categories', style: AppTextStyles.h2.copyWith(fontSize: r.sp(20))),
                const Spacer(),
                Text(
                  'See All',
                  style: AppTextStyles.labelM.copyWith(
                    color: AppColors.amber,
                    fontSize: r.sp(12),
                  ),
                ),
                SizedBox(width: r.w(4)),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.amber, size: r.sp(12)),
              ],
            ),
          ),
        ),

        SizedBox(height: r.h(16)),

        SizedBox(
          height: r.h(96),
          child: ListView.builder(
            controller: _scrollCtrl,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: r.w(16)),
            itemCount: widget.categories.length,
            itemBuilder: (_, i) {
              final item = widget.categories[i];
              final isSelected = i == widget.selectedIndex;
              return ScrollReveal(
                scrollNotifier: widget.scrollNotifier,
                delay: Duration(milliseconds: 60 * i),
                fromOffset: Offset(0, 30),
                child: _CategoryChip(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onSelect(i);
                  },
                  r: r,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
      vsync: this, duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.90)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final color = widget.item.color;

    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) { _press.reverse(); widget.onTap(); },
      onTapCancel: () => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: r.w(70),
          margin: EdgeInsets.symmetric(horizontal: r.w(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: r.w(56),
                height: r.w(56),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? color
                      : color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(r.r(18)),
                  border: Border.all(
                    color: widget.isSelected
                        ? color
                        : color.withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: widget.isSelected
                      ? [BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )]
                      : [],
                ),
                child: Center(
                  child: Text(
                    widget.item.emoji,
                    style: TextStyle(fontSize: r.sp(24)),
                  ),
                ),
              ),
              SizedBox(height: r.h(6)),
              Text(
                widget.item.label,
                style: AppTextStyles.labelS.copyWith(
                  color: widget.isSelected ? color : AppColors.textSecondary,
                  fontSize: r.sp(10),
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
