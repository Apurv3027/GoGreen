import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/address/addresses_screen.dart';
import 'package:go_green/screens/checkout/payment_method_screen.dart';
import 'package:go_green/screens/payment_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  final String userID;
  final String addressID;
  final String orderID;
  final String subTotalAmount;
  final String shippingFeeAmount;
  final String totalAmount;
  final List<dynamic> cartItems;

  const ReviewScreen({
    Key? key,
    required this.userID,
    required this.addressID,
    required this.orderID,
    required this.subTotalAmount,
    required this.shippingFeeAmount,
    required this.totalAmount,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool makeItGift = false;

  double makeItGiftPrice = 100.0;

  late double updatedTotalAmount;

  bool isLoading = false;

  dynamic selectedAddress;
  dynamic selectedUserName;
  dynamic selectedMobileNumber;

  @override
  void initState() {
    super.initState();
    fetchSelectedAddress();
    updatedTotalAmount = double.parse(widget.totalAmount);
  }

  Future<void> fetchSelectedAddress() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = liveApiDomain + 'api/user/$userId/get-selected-address';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        selectedAddress = data['address'];
        selectedUserName = data['user']['fullname'];
        selectedMobileNumber = data['user']['mobile_number'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User has not selected a delivery address',
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
    print("Full Name: " + selectedUserName);
    print("Mobile Number: " + selectedMobileNumber);
    print("Address: " + selectedAddress.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Section
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : selectedAddress != null
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.green, size: 28),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Full Name: " + selectedUserName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Address: ${selectedAddress['street_1'] ?? 'N/A'}, ${selectedAddress['street_2'] ?? 'N/A'},\n${selectedAddress['city'] ?? 'N/A'}, ${selectedAddress['state'] ?? 'N/A'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Mobile Number: " +
                                              selectedMobileNumber,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.map,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: const Icon(Icons.home_outlined),
                                title: const Text('Change Delivery Address'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Get.to(AddressesScreen());
                                  Get.to(AddressesScreen())?.then((_) {
                                    // Fetch the selected address again when coming back from AddressPage
                                    fetchSelectedAddress();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'No delivery address selected',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: const Icon(Icons.home_outlined),
                                title: const Text('Select Delivery Address'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Get.to(AddressesScreen());
                                  Get.to(AddressesScreen())?.then((_) {
                                    // Fetch the selected address again when coming back from AddressPage
                                    fetchSelectedAddress();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

              // Payment Method Section
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.grey.shade300, width: 1),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.shade200,
              //         blurRadius: 6,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: ListTile(
              //     contentPadding: const EdgeInsets.all(16),
              //     leading: const Icon(Icons.payment),
              //     title: const Text('Payment method'),
              //     trailing: const Icon(Icons.arrow_forward_ios),
              //     onTap: () {
              //       // Handle payment method selection
              //     },
              //   ),
              // ),
              // const SizedBox(height: 16),

              // Gift Option Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // SvgPicture.asset(
                        //   "assets/icons/Gift.svg",
                        //   color: Theme.of(context).textTheme.bodyLarge!.color,
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            "assets/icons/Gift.svg",
                            color: Colors.white,
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Make it a Gift',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Wrap it in a gift for \₹100',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: makeItGift,
                      onChanged: (value) {
                        setState(() {
                          makeItGift = value;

                          if (makeItGift) {
                            updatedTotalAmount =
                                double.parse(widget.totalAmount) +
                                    makeItGiftPrice;
                          } else {
                            updatedTotalAmount =
                                double.parse(widget.totalAmount) -
                                    makeItGiftPrice;
                          }
                        });
                      },
                      activeColor: primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Order Summary Section
              OrderSummary(
                subtotal: double.parse(widget.subTotalAmount),
                shippingFee: double.parse(widget.shippingFeeAmount),
                total: double.parse(widget.totalAmount),
                makeItGift: makeItGift ? makeItGiftPrice : 0.0,
                // estimatedVAT: 1,
              ),
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(color: Colors.grey.shade200, blurRadius: 6)
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Order Summary',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       const SizedBox(height: 12),
              //       _buildOrderSummaryRow(
              //         'Subtotal',
              //         '\$24',
              //       ),
              //       const SizedBox(height: 8),
              //       _buildOrderSummaryRow(
              //         'Shipping Fee',
              //         'Free',
              //         color: Colors.green,
              //       ),
              //       const Divider(),
              //       _buildOrderSummaryRow(
              //         'Total (Include of VAT)',
              //         '\$25',
              //         isBold: true,
              //       ),
              //       const SizedBox(height: 8),
              //       _buildOrderSummaryRow(
              //         'Estimated VAT',
              //         '\$1',
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 16),

              // Order Review Section (Sample Product)
              const Text(
                'Review your order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.cartItems.map<Widget>((cartItem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                  cartItem['product']['product_image_url'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem['product']['product_name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Quantity: ${cartItem['quantity']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\₹${cartItem['product']['product_price']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.grey.shade300, width: 1),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.shade200,
              //         blurRadius: 6,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       Container(
              //         height: 50,
              //         width: 50,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(8),
              //           image: const DecorationImage(
              //             image: AssetImage('assets/img/Welcome_logo.png'),
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 16),
              //       const Text('WINTER HOODI'),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedAddress != null
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Handle button press
                  print('Continue button pressed');

                  print('userID: ' + widget.userID);
                  print('addressID: ' + widget.addressID);
                  print('orderID: ' + widget.orderID);
                  print('subTotalAmount: ' + widget.subTotalAmount);
                  print('shippingFeeAmount: ' + widget.shippingFeeAmount);
                  print(
                      'totalAmount: ${(makeItGift ? updatedTotalAmount : widget.totalAmount).toString()}');
                  print('cartItems: ' + widget.cartItems.toString());

                  Get.to(
                    PaymentMethodScreen(
                      userID: widget.userID,
                      addressID: widget.addressID,
                      orderID: widget.orderID,
                      subTotalAmount: widget.subTotalAmount,
                      shippingFeeAmount: widget.shippingFeeAmount,
                      totalAmount:
                          (makeItGift ? updatedTotalAmount : widget.totalAmount)
                              .toString(),
                      cartItems: widget.cartItems,
                    ),
                  );
                  // Get.to(PaymentScreen(
                  //   userID: widget.userID,
                  //   addressID: widget.addressID,
                  //   orderID: widget.orderID,
                  //   totalAmount:
                  //       (makeItGift ? updatedTotalAmount : widget.totalAmount)
                  //           .toString(),
                  //   cartItems: widget.cartItems,
                  // ));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Continue'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // Helper method to build rows in Order Summary section
  Widget _buildOrderSummaryRow(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.black,
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
  final double makeItGift;
  // final double estimatedVAT;

  OrderSummary({
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    required this.makeItGift,
    // required this.estimatedVAT,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
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
          if (makeItGift > 0)
            Column(
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Make it a Gift',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 15),
                    ),
                    Text(
                      '\₹${makeItGift.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: primaryColor,
                            fontSize: 15,
                          ),
                    ),
                  ],
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
                '\₹${(total + makeItGift).toStringAsFixed(2)}',
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
