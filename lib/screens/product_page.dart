// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/shopping_cart.dart';
import 'package:go_green/utility/assets_utility.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/commonMaterialButton.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductPage extends StatefulWidget {
  final int productId;
  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = true;

  late Future<Map<String, dynamic>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProductDetails(widget.productId);
  }

  Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
    final response = await http.get(
      Uri.parse(liveApiDomain + 'api/products/$productId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Print raw response

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No product details found'));
          } else {
            final product = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Get.back(),
                    child: Image(image: backArrow),
                  ),
                  title: Text(
                    product['product']['product_name'] ?? '',
                    style: color000000w90018,
                  ),
                  pinned: _pinned,
                  snap: _snap,
                  floating: _floating,
                  expandedHeight: 400.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      product['product']['product_image_url'] ?? defaultURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: Text(
                                        product['product']['product_name'] ?? '',
                                        style: color000000w60030.copyWith(),
                                      ),
                                    ),
                                    FavoriteButton(
                                      iconColor: Colors.black,
                                      iconSize: 45,
                                      isFavorite: true,
                                      valueChanged: (_isFavorite) {
                                        print(
                                          'Is Favorite $_isFavorite)',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Text(
                                  'Price: ₹${product['product']['product_price'] ?? ''}',
                                  style: colorFF2D55w70026,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                                child: Divider(
                                  color: color000000,
                                  thickness: 0.3,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 15),
                                child: Text(
                                  description,
                                  style: color000000w60020,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: SizedBox(
                                  width: 450,
                                  child: Text(
                                    product['product']['product_description'] ?? '',
                                    style: color000000w40020.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 15),
                                child: Text(
                                  categories,
                                  style: color000000w60020,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: SizedBox(
                                  width: 450,
                                  child: Text(
                                    product['product']['product_category'] ?? '',
                                    style: color000000w40020.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: commonMatButton(
          width: double.infinity,
          onPressed: () {
            Get.to(
              ShoppingCart(),
            );
          },
          txt: addToCart,
          buttonColor: cactusGreen,
        ),
      ),
    );
  }
}
