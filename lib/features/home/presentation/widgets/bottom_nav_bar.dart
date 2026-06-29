import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class ShopBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ShopBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(
      active: Icons.home_rounded,
      inactive: Icons.home_outlined,
      label: 'Home',
    ),
    _NavItem(
      active: Icons.explore_rounded,
      inactive: Icons.explore_outlined,
      label: 'Explore',
    ),
    _NavItem(
      active: Icons.shopping_bag,
      inactive: Icons.shopping_bag_outlined,
      label: 'Cart',
    ),
    _NavItem(
      active: Icons.favorite_rounded,
      inactive: Icons.favorite_border,
      label: 'Wishlist',
    ),
    _NavItem(
      active: Icons.person_rounded,
      inactive: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      height: r.h(72) + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.98),
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (i) => _NavTile(
                item: _items[i],
                isSelected: currentIndex == i,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(i);
                },
                r: r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData active;
  final IconData inactive;
  final String label;

  const _NavItem({
    required this.active,
    required this.inactive,
    required this.label,
  });
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final R r;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: r.w(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isSelected ? r.w(44) : r.w(36),
              height: isSelected ? r.h(32) : r.h(28),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.champagneMuted
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(r.r(10)),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? item.active : item.inactive,
                    key: ValueKey(isSelected),
                    color: isSelected
                        ? AppColors.champagne
                        : AppColors.textMuted,
                    size: r.sp(22),
                  ),
                ),
              ),
            ),
            SizedBox(height: r.h(3)),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? AppColors.champagne : AppColors.textMuted,
                fontSize: r.sp(10),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
