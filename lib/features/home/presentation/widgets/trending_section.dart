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
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: r.w(20)),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: r.w(12),
              mainAxisSpacing: r.h(12),
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => ScrollReveal(
              scrollNotifier: scrollNotifier,
              delay: Duration(milliseconds: 80 * i),
              fromOffset: Offset(0, 50),
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
