import 'package:flutter/material.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/network_image_with_loader.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding / 2),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(defaultBorderRadious * 2),
            ),
            child: NetworkImageWithLoader(widget.image),
          ),
        ),
      ),
    );
  }
}
