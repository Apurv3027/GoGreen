import 'package:flutter/material.dart';
import 'package:go_green/utility/text_utils.dart';

import 'color_utilities.dart';

Widget commonWelcomeButton({
  VoidCallback? onPressed,
  Color? buttonColor,
  String? txt,
  double minWidth = 120,
}) {
  return MaterialButton(
    minWidth: minWidth,
    onPressed: onPressed,
    height: 50,
    color: buttonColor,
    child: Text(
      txt ?? '',
      style: color172F49w70016.copyWith(fontSize: 20, color: charcoalBlack),
    ),
  );
}
