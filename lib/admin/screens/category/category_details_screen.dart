import 'package:flutter/material.dart';
import 'package:go_green/utility/color_utilities.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  CategoryDetailsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category['name']} Details'),
        backgroundColor: cactusGreen,
      ),
      body: Center(child: Text('Category details functionality goes here')),
    );
  }
}