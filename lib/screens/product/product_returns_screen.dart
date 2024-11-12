import 'package:flutter/material.dart';
import 'package:go_green/utility/constants.dart';

class ProductReturnsScreen extends StatelessWidget {
  const ProductReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 40,
                    child: BackButton(),
                  ),
                  Text(
                    "Return",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Text(
                "Free pre-paid returns and exchanges for orders shipped to the IND. Get refunded faster with easy online returns and print a FREE pre-paid return or exchange any unused or defective merchandise by mail or at one of our IND store locations. Made to order items cannot be canceled, exchange or returned.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          ],
        ),
      ),
    );
  }
}
