import 'package:flutter/material.dart';
import 'package:go_green/utility/color_utilities.dart';

class AddCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Category'),
        backgroundColor: cactusGreen,
      ),
      body: Center(child: Text('Add new category functionality goes here')),
    );
  }
}