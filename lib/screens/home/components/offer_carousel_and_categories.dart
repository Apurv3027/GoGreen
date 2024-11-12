import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/models/product_model.dart';
import 'package:go_green/screens/components/product/product_card.dart';
import 'package:go_green/screens/home/components/popular_products.dart';
import 'package:go_green/utility/constants.dart';

import 'categories.dart';
import 'offers_carousel.dart';

class OffersCarouselAndCategories extends StatelessWidget {
  const OffersCarouselAndCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OffersCarousel(),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Categories",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const Categories(),
      ],
    );
  }
}
