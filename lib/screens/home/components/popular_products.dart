import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/models/product_model.dart';
import 'package:go_green/screens/components/product/product_card.dart';
import 'package:go_green/screens/product/product_details_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print raw response

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Response Data: $responseData'); // Print parsed response

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('products')) {
          var productData = responseData['products'];
          setState(() {
            productsList =
                List<Map<String, dynamic>>.from(productData.map((product) {
              return {
                'id': product['id'],
                'name': product['product_name'],
                'price': product['product_price'],
                'img': product['product_image_url'],
                'des': product['product_description'],
                'category_id': product['category_id'],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Popular products",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              var product = productsList[index];

              return Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: index == productsList.length - 1 ? defaultPadding : 0,
                ),
                child: ProductCard(
                  image: product['img'],
                  description: product['des'],
                  title: product['name'],
                  price: product['price'].toString(),
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
        )
      ],
    );
  }
}
