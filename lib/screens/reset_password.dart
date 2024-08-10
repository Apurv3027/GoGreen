import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'logIn_page.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isObscure = false;
  Widget build(BuildContext context) {
    // TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Image(image: backArrow),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reset,
                style: color000000w90038,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                child: Text(
                  changePassTxt,
                  style: color999999w50018,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // commonTextField(name: currentPass, suggestionTxt: currentPass, controller: nameController),
              // SizedBox(
              //   height: 30,
              // ),
              // commonTextField(name: newPass, suggestionTxt: newPass, controller: emailController),
              // SizedBox(
              //   height: 30,
              // ),
              // commonTextField(name: confirmPass, suggestionTxt: confirmPass, controller: emailController),
              // SizedBox(
              //   height: 50,
              // ),
              commonPasswordTextField(
                obsecure: !_isObscure,
                name: passwordSuggestion,
                suggestionTxt: enterPassword,
                action: TextInputAction.next,
                controller: passwordController,
                btn: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: stoneGray,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              commonPasswordTextField(
                obsecure: !_isObscure,
                name: confirmPass,
                suggestionTxt: confirmPass,
                action: TextInputAction.done,
                controller: passwordController,
                btn: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: stoneGray,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),

              SizedBox(
                height: 65,
              ),
              Align(
                  alignment: Alignment.center,
                  child: commonMatButton(
                      onPressed: () {
                        Get.offAll(const LogIn());
                      },
                      txt: save,
                      buttonColor: cactusGreen
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
