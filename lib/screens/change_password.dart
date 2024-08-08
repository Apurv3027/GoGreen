// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isObscure = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController current_passwordController = TextEditingController();
    TextEditingController confirmPass = TextEditingController();
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
                changePss,
                style: color000000w90038,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: Text(
                  changePassTxt,
                  style: color999999w50018,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              commonPasswordTextField(
                obsecure: !_isObscure,
                name: currentPass,
                suggestionTxt: currentPass,
                controller: passwordController,
                btn: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: colorFFCA27,
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
              // commonTextField(name: currentPass, suggestionTxt: currentPass, controller: nameController),
              SizedBox(
                height: 30,
              ),
              commonPasswordTextField(
                obsecure: !_isObscure,
                name: newPass,
                suggestionTxt: newPass,
                controller: current_passwordController,
                btn: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: colorFFCA27,
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
              // commonTextField(name: newPass, suggestionTxt: newPass, controller: emailController),
              SizedBox(
                height: 30,
              ),
              commonPasswordTextField(
                obsecure: !_isObscure,
                name: newPass,
                suggestionTxt: newPass,
                controller: confirmPass,
                btn: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: colorFFCA27,
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
              // commonTextField(name: confirmPass, suggestionTxt: confirmPass, controller: emailController),
              SizedBox(
                height: 50,
              ),
              Align(
                  alignment: Alignment.center,
                  child: commonMatButton(
                      onPressed: () {
                        Get.back();
                      },
                      txt: save,
                      buttonColor: colorFFCA27)),
            ],
          ),
        ),
      ),
    );
  }
}
