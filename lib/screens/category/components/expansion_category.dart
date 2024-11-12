import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_green/utility/constants.dart';

class ExpansionCategory extends StatelessWidget {
  const ExpansionCategory({
    super.key,
    required this.title,
    required this.products,
  });

  final String title;
  final List products;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
      collapsedIconColor: Theme.of(context).textTheme.bodyMedium!.color,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      textColor: Theme.of(context).textTheme.bodyLarge!.color,
      childrenPadding: const EdgeInsets.only(left: defaultPadding * 3.5),
      children: List.generate(
        products.length,
        (index) => Column(
          children: [
            ListTile(
              onTap: () {
                // Navigator.pushNamed(context, onSaleScreenRoute);
              },
              title: Text(
                products[index].title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (index < products.length - 1) const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
