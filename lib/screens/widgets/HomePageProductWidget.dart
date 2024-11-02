import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/product_page.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageProductWidget extends StatefulWidget {
  const HomePageProductWidget({super.key});

  @override
  State<HomePageProductWidget> createState() => _HomePageProductWidgetState();
}

class _HomePageProductWidgetState extends State<HomePageProductWidget> {
  List<Map<String, dynamic>> productsList = [];

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/products'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print raw response

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Response Data: $responseData'); // Print parsed response

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('products')) {
          var categoriesData = responseData['products'];
          setState(() {
            productsList =
                List<Map<String, dynamic>>.from(categoriesData.map((product) {
              return {
                'id': product['id'],
                'name': product['product_name'],
                'price': product['product_price'],
                'img': product['product_image_url'],
              };
            }));
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: productsList.isEmpty
          // ? Center(
          //     child: CircularProgressIndicator(),
          //   )
          ? Center(
              child: Text('No products found'),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(ProductPage(
                        productId: productsList[index]['id'],
                      ));
                    },
                    child: Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                productsList[index]['img'] ?? defaultURL,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 10,
                                right: 12,
                                child: FavoriteButton(
                                  iconColor: cactusGreen,
                                  iconSize: 35,
                                  isFavorite: isFavorite,
                                  valueChanged: (_isFavorite) async {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            productsList[index]['name'],
                            style: color000000w50020.copyWith(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 5),
                          Text(
                            '₹${productsList[index]['price']}',
                            style: colorFF2D55w70026.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: productsList.length,
              // itemCount: (productsList.length / 2).ceil(),
            ),
    );
  }
}
