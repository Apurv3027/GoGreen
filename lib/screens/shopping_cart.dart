import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'adress_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<dynamic> cartItems = [];

  double shippingFeeAmount = 100.0;
  double subTotalAmount = 0.0;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId != null) {
      final String apiUrl = liveApiDomain + 'api/cart/$userId';

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
    } else {
      Get.snackbar('Error', 'User not logged in.',
          snackPosition: SnackPosition.TOP);
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
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.clear,
            color: color000000,
            size: 30,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchCartItems();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                cart,
                style: color000000w90038,
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
                      child: Text(
                        '${cartItems.length} items',
                        style: color000000w90020,
                      ),
                    ),
                    SizedBox(height: 30),
                    if (cartItems.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(cartItem['product']
                                        ['product_image_url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                cartItem['product']['product_name'],
                                style: color000000w50020.copyWith(fontSize: 21),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹ ${cartItem['product']['product_price']}',
                                    style: color999999w40018.copyWith(
                                        fontSize: 17),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Quantity: ${cartItem['quantity']}',
                                    style: color999999w40018.copyWith(
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  int? userId = prefs.getInt('user_id');
                                  int productId = cartItem['product']['id'];

                                  _confirmDeleteFromCart(
                                      context, userId!, productId);
                                },
                                icon: Icon(Icons.delete_outline_rounded),
                                color: Colors.red,
                                iconSize: 30,
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'No items in the cart',
                          style: color000000w50020,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shippingFee,
                        style: color999999w50018.copyWith(
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        subTotal,
                        style: color999999w50018.copyWith(
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        total,
                        style: color000000w50020.copyWith(
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹ $shippingFeeAmount',
                        style: color999999w50018,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '₹ $subTotalAmount',
                        style: color999999w50018,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '₹ $totalAmount',
                        style: color000000w50020,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Align(
                alignment: Alignment.center,
                child: commonMatButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int? userId = prefs.getInt('user_id');

                    // Fetch user addresses from the API
                    final url = liveApiDomain + 'api/user/$userId/addresses';
                    final response = await http.get(Uri.parse(url));
                    List<dynamic> addresses = [];

                    if (response.statusCode == 200) {
                      final data = json.decode(response.body);
                      addresses = data['data']['addresses'];
                    }

                    if (cartItems.isNotEmpty) {
                      // Generate OrderID
                      Random random = Random();
                      int orderID = 100000 + random.nextInt(900000);

                      Get.to(
                        AdressPage(
                          userID: userId.toString(),
                          orderID: orderID.toString(),
                          totalAmount: totalAmount.toString(),
                          cartItems: cartItems,
                        ),
                      );
                    } else {
                      Get.snackbar('Error', 'Your cart is empty.',
                          snackPosition: SnackPosition.TOP);
                    }
                  },
                  txt: checkOut,
                  buttonColor: cartItems.isNotEmpty ? cactusGreen : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
