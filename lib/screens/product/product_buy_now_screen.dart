import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/components/cart_button.dart';
import 'package:go_green/screens/components/custom_modal_bottom_sheet.dart';
import 'package:go_green/screens/product/added_to_cart_message_screen.dart';
import 'package:go_green/screens/product/components/product_list_tile.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/network_image_with_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/product_quantity.dart';
import 'components/unit_price.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductBuyNowScreen extends StatefulWidget {
  final List<dynamic> productItems;

  const ProductBuyNowScreen({
    Key? key,
    required this.productItems,
  }) : super(key: key);

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int productQuantity = 1;

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> addToCartProduct(int userId, int productId, int quantity) async {
    final url = Uri.parse(
      liveApiDomain + 'api/cart/add',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        // Show success toast
        Fluttertoast.showToast(
          msg: "Product added to cart successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Close the current bottom sheet
        Get.back();

        customModalBottomSheet(
          context,
          isDismissible: false,
          child: const AddedToCartMessageScreen(),
        );
      } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Insufficient Stock",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                "Sorry, there is not enough stock for this product.",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                    setState(() {
                      productQuantity = 1;
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print("Error: ${response.statusCode}");
        print("Response body: ${response.body}");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add product to cart.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                    setState(() {
                      productQuantity = 1;
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Get.back();
                  setState(() {
                    productQuantity = 1;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product =
        widget.productItems.isNotEmpty ? widget.productItems[0] : {};

    return Scaffold(
      bottomNavigationBar: CartButton(
        price: double.parse(product['product_price']),
        title: "Add to cart",
        subTitle: "Total price",
        press: () async {
          int? userId = await getUserId();

          if (userId != null) {
            print('User ID: ${userId}');
            print('Product ID: ${product['id']}');
            print('Product Quantity: ${productQuantity}');
            addToCartProduct(userId, product['id'], productQuantity);
          } else {
            // Handle user not logged in case
            print("User not logged in");
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding / 2,
              vertical: defaultPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  product['product_name'] ?? 'Product',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Bookmark.svg",
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child:
                          NetworkImageWithLoader(product['product_image_url']),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: UnitPrice(
                            price: double.parse(product['product_price']),
                          ),
                        ),
                        ProductQuantity(
                          numOfItem: productQuantity,
                          onIncrement: () {
                            setState(() {
                              productQuantity++;
                            });
                          },
                          onDecrement: () {
                            setState(() {
                              if (productQuantity > 1) {
                                productQuantity--;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Text(
                          "Store pickup availability",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Text(
                          product['product_quantity'] > 5
                              ? "In stock - Available for In-Store pickup and shipping."
                              : product['product_quantity'] > 0
                                  ? "Limited stock - Check availability for In-Store pickup options."
                                  : "Currently out of stock - Please select 'Notify Me' to be informed when available.",
                          style: TextStyle(
                            color: product['product_quantity'] > 5
                                ? successColor
                                : product['product_quantity'] > 0
                                    ? warningColor
                                    : errorColor,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Check stores",
                    svgSrc: "assets/icons/Stores.svg",
                    isShowBottomBorder: true,
                    press: () {
                      // customModalBottomSheet(
                      //   context,
                      //   height: MediaQuery.of(context).size.height * 0.92,
                      //   child: const LocationPermissonStoreAvailabilityScreen(),
                      // );
                    },
                  ),
                ),
                // const SliverToBoxAdapter(
                //   child: SizedBox(
                //     height: defaultPadding,
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
