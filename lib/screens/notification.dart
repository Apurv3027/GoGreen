// ignore_for_file: prefer_const_constructors

import 'package:go_green/utility/cs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/color_utilities.dart';
import '../utility/text_utils.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: color000000,
          ),
        ),
        backgroundColor: colorFFFFFF,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              notificationTxt,
              style: color000000w90022.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  width: double.infinity,
                  height: 155,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorCCCCCC,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: colorF4F4F4,
                          ),
                          child: Icon(NotificationList[index].ico),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              NotificationList[index].name ?? '',
                              style: color000000w90022,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              notificationDemoTxt,
                              style: color999999w40016,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  NotificationList[index].time ?? '',
                                  style: color999999w40016,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: NotificationList.length,
          ),
        ],
      ),
    );
  }
}

class Notification {
  IconData? ico;
  String? name;
  String? time;
  Notification({this.ico, this.name, this.time});
}

List<Notification> NotificationList = [
  Notification(
    ico: Icons.lock,
    name: notificationTxt,
    time: justNow,
  ),
  Notification(
    ico: Icons.done,
    name: notificationTxt1,
    time: time1,
  ),
  Notification(
    ico: Icons.inventory,
    name: notificationTxt2,
    time: time2,
  ),
  Notification(
    ico: Icons.payments,
    name: notificationTxt3,
    time: time3,
  ),
];
