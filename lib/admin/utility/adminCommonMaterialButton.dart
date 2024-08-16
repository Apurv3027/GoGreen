import 'package:flutter/material.dart';
import 'package:go_green/utility/color_utilities.dart';

import 'package:go_green/utility/text_utils.dart';

Widget adminCommonMatButton({
  Function()? onPressed,
  Color? buttonColor,
  String? txt,
  double width = 400,
}) {
  return MaterialButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    onPressed: onPressed,
    minWidth: width,
    height: 60,
    color: buttonColor,
    elevation: 0,
    child: Text(
      txt ?? '',
      style: color172F49w40014.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: charcoalBlack),
    ),
  );
}
