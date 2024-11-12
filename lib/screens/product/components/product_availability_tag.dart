import 'package:flutter/material.dart';
import 'package:go_green/utility/constants.dart';

class ProductAvailabilityTag extends StatelessWidget {
  const ProductAvailabilityTag({
    super.key,
    required this.productQuantity,
  });

  final int productQuantity;

  @override
  Widget build(BuildContext context) {

    String message;
    Color backgroundColor;

    if (productQuantity > 5) {
      message = "Available in Stock";
      backgroundColor = successColor;
    } else if (productQuantity == 0) {
      message = "Currently Unavailable";
      backgroundColor = errorColor;
    } else {
      message = "Limited Stock Available";
      backgroundColor = warningColor;
    }

    return Container(
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultBorderRadious / 2),
        ),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
      ),
    );
  }
}
