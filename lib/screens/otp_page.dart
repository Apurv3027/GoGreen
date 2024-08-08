// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_green/screens/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';

import '../utility/cs.dart';
import '../utility/text_utils.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Image(image: backArrow),
        ),
        backgroundColor: colorFFFFFF,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                otp,
                style: color000000w90022.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 26, right: 80, bottom: 32),
                child: Text(
                  textOtp,
                  style: color999999w50018,
                  maxLines: 3,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              OTPTextField(
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 70,
                style: TextStyle(fontSize: 20),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) {
                  // ignore: avoid_print
                  print("Completed: " + pin);
                },
              ),
              SizedBox(
                height: 31,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Center(
                          child: Text(
                            "Resend Otp In",
                            style: color000000w50020.copyWith(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                        ),
                        actions: <Widget>[
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Lottie.asset('assets/img/89550-clock-timer.json', height: 100),
                                SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: SlideCountdown(
                                    icon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Icon(
                                        Icons.timer,
                                        color: colorFFFFFF,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: colorFFCA27,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 150, vertical: 10),
                                    style: colorFFFFFFw80024,
                                    duration: const Duration(minutes: 1),
                                  ),
                                ),
                                // CountdownTimer(
                                //   endTime: endTime,
                                // ),
                              ],
                            ),
                          ),
                          // LanguagePickerDropdown(onValuePicked: (Language language) {
                          //   print(language.name);
                          // }),
                        ],
                      ),
                    );
                    // AlertDialog(
                    //   title: const Text('AlertDialog Title'),
                    //   content: const Text('AlertDialog description'),
                    //   actions: [
                    //     Image(image: clockLottie),
                    //   ],
                    // );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: notOtp.tr,
                      style: color999999w50018,
                      children: [
                        TextSpan(
                          text: resend.tr,
                          style: colorFFCA27w50018,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.center,
                  child: commonMatButton(
                      onPressed: () {
                        Get.to(ResetPassword());
                      },
                      txt: verify,
                      buttonColor: colorFFCA27)),
            ],
          ),
        ),
      ),
    );
  }
}
