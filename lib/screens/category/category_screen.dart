import 'package:flutter/material.dart';
import 'package:go_green/models/category_model.dart';
import 'package:go_green/screens/category/components/expansion_category.dart';
import 'package:go_green/screens/search/components/search_form.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<Map<String, dynamic>> categoriesList = [];

  int selectedCategoryId = 0;

  List<Map<String, dynamic>> productsData = [];

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    if (categoriesList.isNotEmpty) {
      getProductsByCategory(categoriesList[0]['id']);
    }
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

            if (categoriesList.isNotEmpty) {
              selectedCategoryId = categoriesList[activeIndex]['id'];
              // Fetch products for the selected category
              getProductsByCategory(selectedCategoryId);
            }
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

  Future<void> getProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/categories/$categoryId/products'),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if responseData is a Map and contains the list of products
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('products')) {
          List<dynamic> products = responseData['products'];

          setState(() {
            productsData = List<Map<String, dynamic>>.from(products.map((product) {
              return {
                'id': product['id'],
                'product_name': product['product_name'],
                'product_price': product['product_price'],
                'product_image_url': product['product_image_url'],
                'product_description': product['product_description'],
              };
            }));
          });
        } else {
          throw Exception('Unexpected response format for products');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: SearchForm(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Categories",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            // While loading use 👇
            // const Expanded(
            //   child: DiscoverCategoriesSkelton(),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: categoriesList.length,
                itemBuilder: (context, index) => ExpansionCategory(
                  title: categoriesList[index]['name'] ?? 'Category Name',
                  products: (productsData.isNotEmpty && index < productsData.length)
                      ? productsData[index]['product_name']
                      : [],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}