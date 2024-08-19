import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:go_green/screens/categories_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, dynamic>> categoriesList = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/categories'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Print the raw response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if responseData is a Map and contains the list
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('categories')) {
          List<dynamic> categories = responseData['categories'];

          setState(() {
            categoriesList =
                List<Map<String, dynamic>>.from(categories.map((category) {
              return {
                'id': category['id'],
                'name': category['category_name'],
                'items': category['category_item_count'],
                'img': category['category_image_url'],
              };
            }));
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: color000000,
          ),
        ),
        backgroundColor: colorFFFFFF,
        elevation: 1,
        title: Text(
          categories,
          style: color000000w90018,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await fetchCategories();
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: categoriesList.isEmpty
              ? Center(
                  child:
                      CircularProgressIndicator()) // Show loader while fetching data
              : ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(CategoriesProductPage());
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 120, // Fixed width for image
                            height: 120, // Fixed height for image
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: rounded corners
                            ),
                            child: Image.network(
                              categoriesList[index]['img'] ?? defaultURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoriesList[index]['name'] ?? '',
                                  style: color000000w90022,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Items: ${categoriesList[index]['items'] ?? ''}',
                                  style: color999999w40018,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_right,
                            size: 30,
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: categoriesList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
