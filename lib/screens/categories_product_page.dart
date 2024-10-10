import 'package:go_green/screens/product_page.dart';
import 'package:go_green/utility/assets_utility.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesProductPage extends StatefulWidget {
  const CategoriesProductPage({Key? key}) : super(key: key);

  @override
  State<CategoriesProductPage> createState() => _CategoriesProductPageState();
}

class _CategoriesProductPageState extends State<CategoriesProductPage>
    with SingleTickerProviderStateMixin {
  List<String> categories = [];
  Map<String, List<Map<String, dynamic>>> categorizedProducts = {};
  TabController? _controller;
  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final response =
      await http.get(Uri.parse(liveApiDomain + 'api/categories'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        categories = List<String>.from(
            data['categories'].map((category) => category['category_name']));

        setState(() {
          // Only create the TabController after fetching categories
          _controller = TabController(length: categories.length, vsync: this);
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/products'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('products')) {
          List<dynamic> products = responseData['products'];

          for (var product in products) {
            String category = product['category'] ?? 'Product Categories';
            if (!categorizedProducts.containsKey(category)) {
              categorizedProducts[category] = [];
            }

            categorizedProducts[category]?.add({
              'id': product['id'],
              'name': product['product_name'],
              'price': product['product_price'],
              'img': product['product_image_url'],
            });
          }

          setState(() {
            categories = categorizedProducts.keys.toList();
            // Update the controller after fetching products
            _controller?.dispose(); // Dispose previous controller if exists
            _controller = TabController(length: categories.length, vsync: this);
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
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
            categoriesTitle,
            style: color000000w90018,
          ),
          centerTitle: true,
          bottom: _controller != null
              ? TabBar(
            isScrollable: true,
            indicatorColor: Colors.transparent,
            labelColor: color000000,
            unselectedLabelColor: color999999,
            unselectedLabelStyle: color999999w50020.copyWith(fontSize: 20),
            labelStyle: color000000w90020.copyWith(fontSize: 25),
            controller: _controller,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          )
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await fetchProducts();
          },
          child: _controller != null
              ? TabBarView(
            controller: _controller,
            children: categories.map((category) {
              return GridView.builder(
                shrinkWrap: true,
                itemCount: categorizedProducts[category]?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  var product = categorizedProducts[category]![index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(ProductPage(
                          productId: product['id'],
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Image(
                                  image: NetworkImage(product['img']),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 12,
                                  child: FavoriteButton(
                                    iconColor: Colors.black,
                                    iconSize: 35,
                                    isFavorite: true,
                                    valueChanged: (_isFavorite) {
                                      print('Is Favorite $_isFavorite');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            product['name'] ?? '',
                            style: color000000w90020,
                          ),
                          Text(
                            product['price'] ?? '',
                            style: color999999w40020,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
