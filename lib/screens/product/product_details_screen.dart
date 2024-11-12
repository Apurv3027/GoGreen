import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/components/cart_button.dart';
import 'package:go_green/screens/components/custom_modal_bottom_sheet.dart';
import 'package:go_green/screens/components/product/product_card.dart';
import 'package:go_green/screens/components/review_card.dart';
import 'package:go_green/screens/product/product_returns_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import 'product_buy_now_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailsScreen extends StatefulWidget {
  final int productId, categoryId;
  const ProductDetailsScreen({
    Key? key,
    required this.productId,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isProductAvailable = true;
  bool isNotifyMe = false;

  late Future<Map<String, dynamic>> _productFuture;

  List<Map<String, dynamic>> categoryWiseProductsList = [];

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProductDetails(widget.productId);
    fetchCategoryWiseProducts(widget.categoryId);
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
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

  Future<void> fetchCategoryWiseProducts(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse(
          liveApiDomain + 'api/categories/$categoryId/products',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Response Data: $responseData');

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('products')) {
          var categoryWiseProductsData = responseData['products'];
          setState(() {
            categoryWiseProductsList = List<Map<String, dynamic>>.from(
                categoryWiseProductsData.map((categoryWiseProduct) {
              return {
                'id': categoryWiseProduct['id'],
                'name': categoryWiseProduct['product_name'],
                'description': categoryWiseProduct['product_description'],
                'price': categoryWiseProduct['product_price'],
                'img': categoryWiseProduct['product_image_url'],
                'quantity': categoryWiseProduct['product_quantity'],
                'category_id': categoryWiseProduct['category_id'],
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No product details found'));
        } else {
          final product = snapshot.data!;

          return Scaffold(
            bottomNavigationBar: product['product']['product_quantity'] > 0
                ? CartButton(
                    price: double.parse(product['product']['product_price']),
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: ProductBuyNowScreen(
                          productItems: [product['product']],
                        ),
                      );
                    },
                  )
                : NotifyMeCard(
                    isNotify: isNotifyMe,
                    onChanged: (value) {
                      isNotifyMe = true;
                    },
                  ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    floating: true,
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/Bookmark.svg",
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                  ProductImages(
                    image:
                        product['product']['product_image_url'] ?? defaultURL,
                  ),
                  ProductInfo(
                    title: product['product']['product_name'] ?? 'Product Name',
                    productQuantity: product['product']['product_quantity'],
                    description: product['product']['product_description'] ??
                        'Product Description',
                  ),
                  ProductListTile(
                    svgSrc: "assets/icons/Return.svg",
                    title: "Returns",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height / 2,
                        child: const ProductReturnsScreen(),
                      );
                    },
                  ),
                  // ProductListTile(
                  //   svgSrc: "assets/icons/Chat.svg",
                  //   title: "Reviews",
                  //   isShowBottomBorder: true,
                  //   press: () {
                  //     // Navigator.pushNamed(context, productReviewsScreenRoute);
                  //   },
                  // ),
                  SliverPadding(
                    padding: const EdgeInsets.all(defaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "You may also like",
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryWiseProductsList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            left: defaultPadding,
                            right: index == categoryWiseProductsList.length - 1
                                ? defaultPadding
                                : 0,
                          ),
                          child: ProductCard(
                            image: categoryWiseProductsList[index]['img'] ??
                                defaultURL,
                            description: categoryWiseProductsList[index]
                                ['description'],
                            title: categoryWiseProductsList[index]['name'],
                            price: categoryWiseProductsList[index]['price'],
                            press: () {
                              print('productId: ${categoryWiseProductsList[index]['id']}');
                              print('categoryId: ${widget.categoryId}');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
