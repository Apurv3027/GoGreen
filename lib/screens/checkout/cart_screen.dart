import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/checkout/review_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final String userID;
  const CartScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];

  Map<String, dynamic>? userData;

  double shippingFeeAmount = 50.0;
  double subTotalAmount = 0.0;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCartItems();
  }

  Future<void> fetchUserData() async {
    final url = liveApiDomain + 'api/users/${widget.userID}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body)['user'];
        });
        print("User Selected Address ID: " + userData!['selected_address_id'].toString());
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchCartItems() async {
    final String apiUrl = liveApiDomain + 'api/cart/${widget.userID}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            cartItems = responseData['cart_items'];
          });
          calculateSubtotal();
        } else {
          Get.snackbar('Error', responseData['message'],
              snackPosition: SnackPosition.TOP);
        }
      } else if (response.statusCode == 404) {
        print('No items found in the cart.');
      } else {
        Get.snackbar('Error', 'Failed to load cart items.',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  void _confirmDeleteFromCart(BuildContext context, int userId, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Product'),
          content: Text(
              'Are you sure you want to remove this product from your cart?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Remove', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                // Perform the delete operation
                Navigator.of(context).pop(); // Close the dialog

                final String url = liveApiDomain + 'api/cart';
                final response = await http.delete(
                  Uri.parse(url),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'user_id': userId,
                    'product_id': productId,
                  }),
                );

                if (response.statusCode == 200) {
                  // Product removed successfully
                  Get.snackbar('Success', 'Product removed from cart',
                      snackPosition: SnackPosition.BOTTOM);
                  print('Product removed from cart');

                  // Fetch updated cart items
                  fetchCartItems();
                  setState(() {});
                } else {
                  // Handle error
                  Get.snackbar(
                      'Error', 'Failed to remove product: ${response.body}',
                      snackPosition: SnackPosition.BOTTOM);
                  print('Failed to remove product: ${response.body}');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void calculateSubtotal() {
    subTotalAmount = 0.0;
    print("Calculating subtotal for cart items: $cartItems");

    for (var item in cartItems) {
      double productPrice =
          double.tryParse(item['product']['product_price'].toString()) ?? 0.0;
      int quantity = item['quantity'] ?? 0;

      print(
          "Item: ${item['product']['product_name']}, Quantity: $quantity, Price: $productPrice");

      if (quantity > 0 && productPrice > 0) {
        subTotalAmount += quantity * productPrice;
      }
    }

    totalAmount = subTotalAmount + shippingFeeAmount;
    setState(() {});

    // Debugging output
    print("Subtotal: $subTotalAmount, Total: $totalAmount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: cartItems.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review your order',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return Column(
                          children: [
                            OrderItem(
                              imageUrl: cartItem['product']
                                  ['product_image_url'],
                              title: cartItem['product']['product_name'],
                              price: double.parse(
                                  cartItem['product']['product_price']),
                              quantity: cartItem['quantity'],
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                    // First Item
                    // OrderItem(
                    //   imageUrl: defaultURL,
                    //   title: 'Sleeveless Tiered Dobby...',
                    //   price: 299.43,
                    //   // originalPrice: 534.33,
                    // ),
                    // SizedBox(height: 16),
                    // // Second Item
                    // OrderItem(
                    //   imageUrl: defaultURL,
                    //   title: 'Printed Sleeveless Tiered...',
                    //   price: 299.43,
                    //   // originalPrice: 534.33,
                    // ),
                    SizedBox(height: 24),
                    Text(
                      'Your Coupon code',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Type coupon code',
                        prefixIcon: Icon(Icons.discount_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Order Summary
                    OrderSummary(
                      subtotal: subTotalAmount,
                      shippingFee: shippingFeeAmount,
                      total: totalAmount,
                      // estimatedVAT: 1,
                    ),
                    SizedBox(height: 24),
                    // OrderSummary(
                    //   subtotal: 24,
                    //   shippingFee: 'Free',
                    //   total: 25,
                    //   estimatedVAT: 1,
                    // ),
                    // Spacer(),
                    // Checkout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          // Generate OrderID
                          Random random = Random();
                          int orderID = 100000 + random.nextInt(900000);

                          print("userID: " + widget.userID);
                          print("addressID: " + userData!['selected_address_id'].toString());
                          print("orderID: " + orderID.toString());
                          print("subTotalAmount: " + subTotalAmount.toString());
                          print("shippingFeeAmount: " + shippingFeeAmount.toString());
                          print("totalAmount: " + totalAmount.toString());
                          print("cartItems: " + cartItems.toString());

                          Get.to(ReviewScreen(
                            userID: widget.userID,
                            addressID: userData!['selected_address_id'].toString(),
                            orderID: orderID.toString(),
                            subTotalAmount: subTotalAmount.toString(),
                            shippingFeeAmount: shippingFeeAmount.toString(),
                            totalAmount: totalAmount.toString(),
                            cartItems: cartItems,
                          ));
                        },
                        child: Text('Checkout'),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review your order',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: Text(
                        'No items in the cart',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  // final double originalPrice;

  OrderItem({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    // required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\₹${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Quantity: ${quantity}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  // SizedBox(width: 8),
                  // Text(
                  //   '\₹${originalPrice.toStringAsFixed(2)}',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey,
                  //     decoration: TextDecoration.lineThrough,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double total;
  // final double estimatedVAT;

  OrderSummary({
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    // required this.estimatedVAT,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 22),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15),
              ),
              Text(
                '\₹${subtotal.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Fee',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15),
              ),
              Text(
                '\₹${shippingFee.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.green,
                      fontSize: 15,
                    ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   'Total (Include of VAT)',
              //   style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //         fontSize: 15,
              //       ),
              // ),
              Text(
                'Total',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                    ),
              ),
              Text(
                '\₹${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 15,
                    ),
              ),
            ],
          ),
          // SizedBox(height: 8),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Estimated VAT',
          //       style: Theme.of(context)
          //           .textTheme
          //           .labelSmall!
          //           .copyWith(fontSize: 15),
          //     ),
          //     Text(
          //       '\₹${estimatedVAT.toStringAsFixed(2)}',
          //       style: Theme.of(context)
          //           .textTheme
          //           .labelSmall!
          //           .copyWith(fontSize: 15),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
