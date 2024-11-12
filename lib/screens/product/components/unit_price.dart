import 'package:flutter/material.dart';
import 'package:go_green/utility/constants.dart';

class UnitPrice extends StatelessWidget {
  const UnitPrice({
    super.key,
    required this.price,
  });

  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Unit price",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: defaultPadding / 1),
        Text(
          "\₹${price.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
