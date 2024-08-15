// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/add_adress.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class AdressPage extends StatefulWidget {
  const AdressPage({Key? key}) : super(key: key);

  @override
  State<AdressPage> createState() => _AdressPageState();
}

bool isChecked = false;
bool isChecked1 = false;

class _AdressPageState extends State<AdressPage> {
  @override
  Widget build(BuildContext context) {
    // Color getColor(Set<MaterialState> states) {
    //   const Set<MaterialState> interactiveStates = <MaterialState>{
    //     MaterialState.pressed,
    //     MaterialState.hovered,
    //     MaterialState.focused,
    //   };
    //   if (states.any(interactiveStates.contains)) {
    //     return Colors.red;
    //   }
    //   return colorFFCA27;
    // }

    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Image(image: backArrow),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => Get.to(AddAddress()),
              child: Icon(
                Icons.add,
                size: 35,
                color: color000000,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                addressTxt,
                style: color000000w90038,
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorFFFFFF,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0.0, 1), // changes position of shadow
                    ),
                  ],
                  // border: Border.all(color: color000000, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user,
                          style: color000000w90020,
                        ),
                        Text(
                          editTxt,
                          style: colorFFCA27w50018.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            color: cactusGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 350,
                      child: Text(
                        address,
                        style: color000000w90016.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            // child: Theme(
                            //   child: Checkbox(
                            //     value: false,
                            //     onChanged: (bool? value) {
                            //       setState(() {
                            //         isChecked = value!;
                            //       });
                            //     },
                            //   ),
                            //   data: ThemeData(
                            //     primarySwatch: Colors.blue,
                            //     unselectedWidgetColor: Colors.grey, // Your color
                            //   ),
                            // ),
                            child: Theme(
                              child: Checkbox(
                                activeColor: cactusGreen,
                                focusColor: Colors.black,
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: -4),
                                checkColor: Colors.white,
                                // fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                    if (isChecked) {
                                      isChecked1 = false;
                                    }
                                  });
                                },
                              ),
                              data: ThemeData(
                                primarySwatch: Colors.blue,
                                unselectedWidgetColor:
                                    Colors.grey, // Your color
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 28,
                            child: Text(
                              checkBoxTxt,
                              style: color000000w50020.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorFFFFFF,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0.0, 1), // changes position of shadow
                    ),
                  ],
                  // border: Border.all(color: color000000, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user,
                          style: color000000w90020,
                        ),
                        Text(
                          editTxt,
                          style: colorFFCA27w50018.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            color: cactusGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 350,
                      child: Text(
                        address,
                        style: color000000w90016.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Theme(
                              child: Checkbox(
                                activeColor: cactusGreen,
                                focusColor: Colors.black,
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: -4),
                                checkColor: Colors.white,
                                // fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: isChecked1,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked1 = value!;
                                    if (isChecked1) {
                                      isChecked = false;
                                    }
                                  });
                                },
                              ),
                              data: ThemeData(
                                primarySwatch: Colors.blue,
                                unselectedWidgetColor:
                                    Colors.grey, // Your color
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 28,
                            child: Text(
                              checkBoxTxt,
                              style: color000000w50020.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
