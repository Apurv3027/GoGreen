// import 'package:flutter/cupertino.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:flutter/material.dart';

// class commonTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String name;
//   final String suggestionTxt;
//
//   const commonTextField({Key? key, required this.name, required this.controller, required this.suggestionTxt}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(name, style: color999999w50018),
//         TextFormField(
//           controller: controller,
//           cursorColor: Colors.amber,
//           decoration: InputDecoration(
//             hintText: suggestionTxt,
//             focusedBorder: const UnderlineInputBorder(
//                 borderSide: BorderSide(
//               color: colorFFCA27,
//             )),
//           ),
//         ),
//       ],
//     );
//   }
// }

Widget adminCommonTextField({
  TextEditingController? controller,
  String? name,
  TextInputType? keyBoard,
  String? hintText,
  String? suggestionTxt,
  TextInputAction? action,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(name ?? '', style: color999999w40016.copyWith(fontSize: 17)),
      TextFormField(
        textInputAction: action,
        controller: controller,
        cursorColor: earthyBrown,
        keyboardType: keyBoard,
        decoration: InputDecoration(
          hintText: suggestionTxt,
          hintStyle: TextStyle(fontSize: 20),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: earthyBrown,
            ),
          ),
        ),
      ),
    ],
  );
}
