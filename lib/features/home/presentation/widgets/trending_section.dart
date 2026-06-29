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

    // Section-level entrance animation is handled by the page-entrance system
    // in home_page.dart. Individual cards get scroll-tilt via scrollNotifier.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.w(16)),
      child: GridView.builder(
        padding: EdgeInsets.only(top: r.h(4)),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: r.w(12),
          mainAxisSpacing: r.h(12),
          childAspectRatio: 0.60,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) => ScrollReveal(
          scrollNotifier: scrollNotifier,
          delay: Duration(milliseconds: 50 * i),
          duration: const Duration(milliseconds: 700),
          fromOffset: Offset(i.isEven ? -18 : 18, 20),
          fromScale: 0.955,
          fromBlur: 0,
          use3d: false,
          triggerFraction: 0.99,
          parallaxExtent: 20,
          parallaxScale: 0.022,
          minVisibleOpacity: 0.5,
          exitDriftFactor: 0.64,
          child: ProductCard(
            product: products[i],
            onAddToCart: onAddToCart,
            scrollNotifier: scrollNotifier,
          ),
        ),
      ),
    );
  }
}
