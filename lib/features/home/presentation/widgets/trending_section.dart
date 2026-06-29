import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import 'product_card.dart';
import 'scroll_reveal.dart';

class TrendingSection extends StatelessWidget {
  final List<Product> products;
  final ValueNotifier<double> scrollNotifier;
  final VoidCallback onAddToCart;

  const TrendingSection({
    super.key,
    required this.products,
    required this.scrollNotifier,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    // Wrap the whole grid in ONE ScrollReveal instead of per-item reveals.
    // Per-item reveals with fromOffset(0,40) cause an invisible first row
    // to reserve full height, creating a large empty gap before visible items.
    return ScrollReveal(
      scrollNotifier: scrollNotifier,
      fromOffset: const Offset(0, 30),
      fromBlur: 0,        // no blur — avoids any layout side-effects
      fromScale: 0.97,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.w(16)),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: r.w(12),
            mainAxisSpacing: r.h(12),
            childAspectRatio: 0.60,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(
            product: products[i],
            onAddToCart: onAddToCart,
            // No scrollNotifier tilt here — keep grid items stable
          ),
        ),
      ),
    );
  }
}
