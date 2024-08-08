import 'package:go_green/utility/CommonappBar.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:flutter/material.dart';

import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController street1Controller = TextEditingController();
    TextEditingController street2Controller = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                addNewAddress,
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
              child: commonTextField(name: street1, suggestionTxt: enterStreet1, controller: street1Controller),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: commonTextField(name: street1, suggestionTxt: enterStreet2, controller: street2Controller),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: commonTextField(name: street2, suggestionTxt: enterMail, controller: emailController),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: commonTextField(name: city, suggestionTxt: enterCity, controller: cityController),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: commonTextField(name: state, suggestionTxt: enterState, controller: stateController),
            ),
            SizedBox(
              height: 145,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 50),
              child: Align(
                  alignment: Alignment.center,
                  child:
                  commonMatButton(
                      width: double.infinity,
                      onPressed: () {
                        // Get.to();
                      },
                      txt: addNewAddress1,
                      buttonColor: colorFFCA27)),
            ),
          ],
        ),
      ),
    );
  }
}
