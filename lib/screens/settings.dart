// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/change_password.dart';
import 'package:go_green/utility/CommonappBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_cupertino.dart';
import 'package:language_picker/languages.dart';

import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool switchState = false;
  Language _selectedCupertinoLanguage = Languages.korean;

// It's sample code of Cupertino Item.
  void _openCupertinoLanguagePicker() => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return LanguagePickerCupertino(
          pickerSheetHeight: 200.0,
          onValuePicked: (Language language) => setState(() {
            _selectedCupertinoLanguage = language;
            print(_selectedCupertinoLanguage.name);
            print(_selectedCupertinoLanguage.isoCode);
          }),
        );
      });
  Widget build(BuildContext context) {
    // var language;
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              settings,
              style: color000000w90038,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Get.to(ChangePassword()),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        changePss,
                        style: color000000w50020,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: color999999,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 1,
                  thickness: 1,
                ),
              ),
              InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Text("Change Language"),
                    actions: <Widget>[
                      Column(
                        children: [
                          LanguagePickerCupertino(onValuePicked: (
                            Language language,
                          ) {
                            print(language.name);
                          })
                        ],
                      )
                      // LanguagePickerDropdown(onValuePicked: (Language language) {
                      //   print(language.name);
                      // }),
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        changeLan,
                        style: color000000w50020,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: color999999,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 1,
                  thickness: 1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notificationTxt,
                      style: color000000w50020,
                    ),
                    CupertinoSwitch(
                      activeColor: colorFFCA27,
                      value: switchState,
                      onChanged: (bool value) {
                        setState(() {
                          print(value);
                          switchState = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
