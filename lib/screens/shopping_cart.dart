// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'adress_page.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({Key? key}) : super(key: key);

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
      body: Column(
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
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                    child: Text(
                      items,
                      style: color000000w90020,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
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
                              style: color000000w50020.copyWith(fontSize: 21),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              productPrice,
                              style: color999999w40018.copyWith(fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(color: color000000, borderRadius: BorderRadius.circular(50)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  black,
                                  style: color999999w50018.copyWith(fontWeight: FontWeight.normal, fontSize: 17),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Image(
                          image: lightImg,
                          height: 110,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              light,
                              style: color000000w50020.copyWith(fontSize: 21),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              productPrice,
                              style: color999999w40018.copyWith(fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(color: colorFFCA27, borderRadius: BorderRadius.circular(50)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  yellow,
                                  style: color999999w50018.copyWith(fontWeight: FontWeight.normal, fontSize: 17),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
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
                              style: color000000w50020.copyWith(fontSize: 21),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              productPrice,
                              style: color999999w40018.copyWith(fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(color: colorFFCA27, borderRadius: BorderRadius.circular(50)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  yellow,
                                  style: color999999w50018.copyWith(fontWeight: FontWeight.normal, fontSize: 17),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
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
                              style: color000000w50020.copyWith(fontSize: 21),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              productPrice,
                              style: color999999w40018.copyWith(fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(color: colorFFCA27, borderRadius: BorderRadius.circular(50)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  yellow,
                                  style: color999999w50018.copyWith(fontWeight: FontWeight.normal, fontSize: 17),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
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
                      style: color999999w50018.copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      subTotal,
                      style: color999999w50018.copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      total,
                      style: color000000w50020.copyWith(fontWeight: FontWeight.normal),
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
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Align(
                alignment: Alignment.center,
                child: commonMatButton(
                    onPressed: () {
                      Get.to(AdressPage());
                    },
                    txt: checkOut,
                    buttonColor: colorFFCA27)),
          ),
        ],
      ),
    );
  }
}
