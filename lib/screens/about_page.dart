// ignore_for_file: prefer_const_constructors

import 'package:go_green/utility/CommonappBar.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:flutter/material.dart';

import '../utility/cs.dart';
import '../utility/text_utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              aboutUs,
              style: color000000w90038,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
            ),
            child: Text(
              lorem,
              style: color000000w60020,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                loremTxt,
                style: color999999w50018,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
            ),
            child: Text(
              lorem,
              style: color000000w60020,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                loremTxt,
                style: color999999w50018,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
