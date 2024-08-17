import 'package:flutter/material.dart';
import 'package:go_green/utility/color_utilities.dart';

class EditBannerScreen extends StatelessWidget {
  final Map<String, String> bannerData;

  const EditBannerScreen({Key? key, required this.bannerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Banner'),
        backgroundColor: cactusGreen,
      ),
      body: Center(
        child: Text('Edit Banner Screen for ${bannerData['title']}'),
      ),
    );
  }
}