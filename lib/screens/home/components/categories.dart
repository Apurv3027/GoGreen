import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_green/models/product_model.dart';
import 'package:go_green/screens/components/product/product_card.dart';
import 'package:go_green/screens/product/product_details_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
            productsData =
                List<Map<String, dynamic>>.from(products.map((product) {
              return {
                'id': product['id'],
                'product_name': product['product_name'],
                'product_price': product['product_price'],
                'product_image_url': product['product_image_url'],
                'product_description': product['product_description'],
                'category_id': product['category_id'],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding),
        // Categories Section
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                categoriesList.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? defaultPadding : defaultPadding / 2,
                    right:
                        index == categoriesList.length - 1 ? defaultPadding : 0,
                  ),
                  child: CategoryBtn(
                    category: categoriesList[index]['name'],
                    isActive: index == activeIndex,
                    press: () {
                      setState(() {
                        activeIndex = index;
                      });

                      // Fetch products for the selected category
                      getProductsByCategory(categoriesList[index]['id']);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding / 2),

        // Popular Products Section
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productsData.length, // Use the length of productsData
            itemBuilder: (context, index) {
              var product = productsData[index]; // Get each product data

              return Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: index == productsData.length - 1 ? defaultPadding : 0,
                ),
                child: CategoryProductCard(
                  image: product['product_image_url'],
                  title: product['product_name'],
                  description: product['product_description'],
                  price: product['product_price'],
                  press: () {
                    Get.to(
                      ProductDetailsScreen(
                        productId: product['id'],
                        categoryId: product['category_id'],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(
        Radius.circular(
          30,
        ),
      ),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
            color:
                isActive ? Colors.transparent : Theme.of(context).dividerColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              30,
            ),
          ),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null)
              const SizedBox(
                width: defaultPadding / 2,
              ),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
