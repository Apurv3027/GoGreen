import 'package:flutter/material.dart';
import 'package:go_green/utility/constants.dart';

class OnboardingContent extends StatefulWidget {
  final bool isTextOnTop;
  final String title, description, image;

  const OnboardingContent({
    super.key,
    this.isTextOnTop = false,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),

        if (widget.isTextOnTop)
          OnbordTitleDescription(
            title: widget.title,
            description: widget.description,
          ),
        if (widget.isTextOnTop) const Spacer(),

        /// if you are using SVG then replace [Image.asset] with [SvgPicture.asset]

        Image.asset(
          widget.image,
          height: 250,
        ),
        if (!widget.isTextOnTop) const Spacer(),
        if (!widget.isTextOnTop)
          const OnbordTitleDescription(
            title: "Find the item you’ve \nbeen looking for",
            description:
            "Here you’ll see rich varieties of goods, carefully classified for seamless browsing experience.",
          ),

        const Spacer(),
      ],
    );
  }
}

class OnbordTitleDescription extends StatelessWidget {
  const OnbordTitleDescription({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: defaultPadding),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}