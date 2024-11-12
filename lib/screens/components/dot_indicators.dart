import 'package:flutter/material.dart';
import 'package:go_green/utility/constants.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.inActiveColor,
    this.activeColor = primaryColor,
  });

  final bool isActive;

  final Color? inActiveColor, activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: defaultDuration,
      height: isActive ? 15 : 5,
      width: 5,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor
            : inActiveColor ?? primaryMaterialColor.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
      ),
    );
  }
}
