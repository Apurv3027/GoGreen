// ignore_for_file: prefer_const_constructors

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/product_page.dart';

import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeauturedScreen extends StatefulWidget {
  const FeauturedScreen({super.key});

  @override
  State<FeauturedScreen> createState() => _FeauturedScreenState();
}

class _FeauturedScreenState extends State<FeauturedScreen> {

  List<Map<String, dynamic>> productsList = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/products'),
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
            responseData.containsKey('products')) {
          List<dynamic> products = responseData['products'];

          setState(() {
            productsList =
            List<Map<String, dynamic>>.from(products.map((product) {
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
          featured,
          style: color000000w90018,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await fetchProducts();
        },
        child: GridView.builder(
        shrinkWrap: true,
        itemCount: productsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                Get.to(ProductPage(productId: productsList[index]['id'],));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        productsList[index]['img'] ?? defaultURL,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: FavoriteButton(
                          iconColor: cactusGreen,
                          iconSize: 35,
                          isFavorite: true,
                          valueChanged: (_isFavorite) {
                            print(
                              'Is Favorite $_isFavorite)',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    productsList[index]['name'] ?? '',
                    style: TextStyle(
                      color: color000000,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    productsList[index]['price'] ?? '',
                    style: color999999w40020,
                  ),
                ],
              ),
            ),
          );
        },
      ),),
    );
  }
}