import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_green/entry_point.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:image/image.dart' as img;

class ConfirmOrderScreen extends StatefulWidget {
  final String userID;
  final String orderID;
  final String totalAmount;
  final int paymentMethod;
  final double deliveryCharge;
  final List<dynamic> cartItems;

  final String orderStatus;

  const ConfirmOrderScreen({
    Key? key,
    required this.userID,
    required this.orderID,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryCharge,
    required this.cartItems,
    required this.orderStatus,
  }) : super(key: key);

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  Map<String, dynamic>? userData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails(widget.userID);
  }

  Future<void> fetchUserDetails(String userId) async {
    final url = liveApiDomain + 'api/users/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body)['user'];
          isLoading = false;
        });
      } else {
        print('Failed to load user');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(EntryPoint());
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              generatePdfReceipt(
                widget.orderID,
                double.parse(widget.totalAmount),
                List<Map<String, dynamic>>.from(widget.cartItems),
              );
            },
            icon: SvgPicture.asset(
              "assets/icons/Download.svg",
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          IconButton(
            onPressed: () {
              sharePdfReceipt(
                widget.orderID,
                double.parse(widget.totalAmount),
                List<Map<String, dynamic>>.from(widget.cartItems),
              );
            },
            icon: SvgPicture.asset(
              "assets/icons/Share.svg",
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : userData != null
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/Illustration/success.png',
                              height: 300,
                            ),
                            SizedBox(height: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Thanks for your order',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 24,
                                      ),
                                ),
                                SizedBox(height: 10),
                                Text.rich(
                                  TextSpan(
                                    text: "You'll receive an email at ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 16,
                                        ),
                                    children: [
                                      TextSpan(
                                        text: userData!['email'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      TextSpan(
                                        text: " once your order is Confirmed.",
                                      ),
                                    ],
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 20),
                            OrderDetails(
                              orderNumber: "#${widget.orderID}",
                              paidAmount: double.parse(widget.totalAmount),
                              deliveryCharge: widget.deliveryCharge,
                              orderStatus: widget.orderStatus,
                            ).paddingSymmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            ProductSummary(
                              cartItems: widget.cartItems,
                            ).paddingSymmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'User is not authorized.',
                  ),
                ),
    );
  }

  void generatePdfReceipt(String orderID, double totalAmount,
      List<Map<String, dynamic>> cartItems) async {
    final pdf = pw.Document();

    // Load the font that supports the ₹ symbol
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Thanks for your order',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.RichText(
                          text: pw.TextSpan(
                            text: "You'll receive an email at ",
                            style: pw.TextStyle(
                              fontSize: 16,
                              font: ttf,
                            ),
                            children: [
                              pw.TextSpan(
                                text: userData!['email'],
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                  font: ttf,
                                ),
                              ),
                              pw.TextSpan(
                                text: " once your order is Confirmed.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Order Details',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        // Order Number Row
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Order Number',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                            pw.Text(
                              "#${widget.orderID}",
                              style: pw.TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        // Delivery Charge Section
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Delivery Charge',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                            pw.Text(
                              '${widget.deliveryCharge}',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        // Amount Paid Row
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Amount Paid',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                            pw.Text(
                              '${double.parse(widget.totalAmount)}',
                              style: pw.TextStyle(
                                color: PdfColor.fromHex('#4CAF50'),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Product Details',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        // Generate product list
                        ...cartItems.map<pw.Widget>((cartItem) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 16),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        cartItem['product']['product_name'],
                                        style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        'Quantity: ${cartItem['quantity']}',
                                        style: pw.TextStyle(
                                          fontSize: 14,
                                          color: PdfColor.fromHex('#cccccc'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.Text(
                                  '${cartItem['product']['product_price']}',
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#4CAF50'),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Display the PDF for preview and printing
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'order_receipt_$orderID.pdf',
    );
  }

  void sharePdfReceipt(String orderID, double totalAmount,
      List<Map<String, dynamic>> cartItems) async {
    final pdf = pw.Document();

    // Load the font that supports the ₹ symbol
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Thanks for your order',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.RichText(
                          text: pw.TextSpan(
                            text: "You'll receive an email at ",
                            style: pw.TextStyle(
                              fontSize: 16,
                              font: ttf,
                            ),
                            children: [
                              pw.TextSpan(
                                text: userData!['email'],
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                  font: ttf,
                                ),
                              ),
                              pw.TextSpan(
                                text: " once your order is Confirmed.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Order Details',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        // Order Number Row
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Order Number',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                            pw.Text(
                              "#${widget.orderID}",
                              style: pw.TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        // Delivery Charge Section
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Delivery Charge',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                            pw.Text(
                              '${widget.deliveryCharge}',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        // Amount Paid Row
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Amount Paid',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                            pw.Text(
                              '${double.parse(widget.totalAmount)}',
                              style: pw.TextStyle(
                                color: PdfColor.fromHex('#4CAF50'),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Product Details',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        // Generate product list
                        ...cartItems.map<pw.Widget>((cartItem) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 16),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        cartItem['product']['product_name'],
                                        style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        'Quantity: ${cartItem['quantity']}',
                                        style: pw.TextStyle(
                                          fontSize: 14,
                                          color: PdfColor.fromHex('#cccccc'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.Text(
                                  '${cartItem['product']['product_price']}',
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#4CAF50'),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save or share the PDF with a custom name
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'order_receipt_$orderID.pdf', // Custom PDF name
    );
  }
}

class OrderDetails extends StatelessWidget {
  final String orderNumber;
  final double paidAmount;
  final double deliveryCharge;
  final String orderStatus;

  OrderDetails({
    required this.orderNumber,
    required this.paidAmount,
    required this.deliveryCharge,
    required this.orderStatus,
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
            'Order Details',
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 22),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Number',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15),
              ),
              Text(
                orderNumber,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 8),
          if (paymentMethod != 0)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Charge',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 15),
                    ),
                    Text(
                      deliveryCharge.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount Paid',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15),
              ),
              Text(
                '\₹${paidAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.green,
                      fontSize: 15,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Status',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15),
              ),
              Text(
                orderStatus,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 15,
                      color: warningColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductSummary extends StatelessWidget {
  final List<dynamic> cartItems;

  ProductSummary({
    required this.cartItems,
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
            'Product Details',
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 22),
          ),
          SizedBox(height: 8),
          ...cartItems.map<Widget>((cartItem) {
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
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
