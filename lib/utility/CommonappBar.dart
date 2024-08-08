import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'assets_utility.dart';
import 'color_utilities.dart';

// class CommonAppBar extends StatelessWidget {
//   const CommonAppBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

commonAppBar({
  GestureTapCallback? onTap,
}) {
  return AppBar(
    backgroundColor: colorFFFFFF,
    elevation: 0,
    leading: GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: const Image(image: backArrow),
    ),
  );
}
