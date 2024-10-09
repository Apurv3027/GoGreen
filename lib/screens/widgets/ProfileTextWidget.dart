import 'package:flutter/material.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/text_utils.dart';

Widget commonTextDisplay({
  required String title,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: colorCCCCCC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: color999999w40016.copyWith(fontSize: 17),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: color000000w90020,
          ),
        ],
      ),
    ),
  );
}