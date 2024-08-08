// ignore_for_file: prefer_const_constructors

import 'package:go_green/utility/CommonappBar.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/text_utils.dart';

class OrdersDetails extends StatelessWidget {
  const OrdersDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                orderDetails,
                style: color000000w90038,
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        id,
                        style: color999999w40018.copyWith(fontSize: 17),
                      ),
                      Container(
                        width: 115,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: color028C04,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            completed,
                            style: colorFFFFFFw50016,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    date,
                    style: color999999w40018.copyWith(
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    deliveredto,
                    style: color999999w40018.copyWith(
                        fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    address2,
                    style: color000000w90018,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    paymentMethod,
                    style: color999999w40018.copyWith(
                        fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    card,
                    style: color000000w90020.copyWith(
                        fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image(
                              image: chairImg,
                              height: 110,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  proname,
                                  style:
                                      color000000w50020.copyWith(fontSize: 21),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  productPrice,
                                  style:
                                      color999999w40018.copyWith(fontSize: 17),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          color: color000000,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      black,
                                      style: color999999w50018.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Image(
                              image: lampsImg,
                              height: 110,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clock,
                                  style:
                                      color000000w50020.copyWith(fontSize: 21),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  productPrice,
                                  style:
                                      color999999w40018.copyWith(fontSize: 17),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          color: colorFFCA27,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      yellow,
                                      style: color999999w50018.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Image(
                              image: lampsImg,
                              height: 110,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clock,
                                  style:
                                      color000000w50020.copyWith(fontSize: 21),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  productPrice,
                                  style:
                                      color999999w40018.copyWith(fontSize: 17),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          color: colorFFCA27,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      yellow,
                                      style: color999999w50018.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
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
                          // Text(
                          //   dimensions,
                          //   style: color999999w50018.copyWith(fontWeight: FontWeight.normal),
                          // ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            price,
                            style: color999999w50018,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            price2,
                            style: color999999w50018,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            price3,
                            style: color000000w50020,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 10),
                    child: Align(
                        alignment: Alignment.center,
                        child: commonMatButton(
                            onPressed: () {
                              Get.back();
                            },
                            txt: reOrder,
                            buttonColor: colorFFCA27)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
