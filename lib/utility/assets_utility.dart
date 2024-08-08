import 'package:flutter/material.dart';

import 'cs.dart';

const ExactAssetImage splash = ExactAssetImage('assets/img/Splash.png');
const ExactAssetImage welcomeBg = ExactAssetImage('assets/img/bg.png');
const ExactAssetImage welcomeShadow = ExactAssetImage('assets/img/shadow.png');
const ExactAssetImage welcomeLogo = ExactAssetImage('assets/img/Welcome_logo3.png');
const ExactAssetImage logo = ExactAssetImage('assets/img/Welcome_logo.png');
const ExactAssetImage LogoWhite = ExactAssetImage('assets/img/Welcome_LogoWhite.png');
const ExactAssetImage LogoBlack = ExactAssetImage('assets/img/Welcome_LogoBlack.png');
const ExactAssetImage WhiteLogo = ExactAssetImage('assets/img/Welcome_WhiteLogo.png');
const ExactAssetImage BlackLogo = ExactAssetImage('assets/img/Welcome_BlackLogo.png');
const ExactAssetImage backArrow = ExactAssetImage('assets/img/ArrowLeft.png');
const ExactAssetImage notification = ExactAssetImage('assets/img/notification.png');
const ExactAssetImage chairImg = ExactAssetImage('assets/img/Chair01.png');
const ExactAssetImage lightImg = ExactAssetImage('assets/img/Ceiling.png');
const ExactAssetImage watch = ExactAssetImage('assets/img/Floor.png');
const ExactAssetImage metalchair = ExactAssetImage('assets/img/Furniture.png');
const ExactAssetImage woodenImg = ExactAssetImage('assets/img/Wooden.png');
const ExactAssetImage lampsImg = ExactAssetImage('assets/img/Lamps.png');
const ExactAssetImage collectionBg = ExactAssetImage('assets/img/collectionBg.png');
const ExactAssetImage mask = ExactAssetImage('assets/img/Mask.png');
const ExactAssetImage mask1 = ExactAssetImage('assets/img/Mask (1).png');
const ExactAssetImage mask2 = ExactAssetImage('assets/img/Mask (2).png');
const ExactAssetImage mask3 = ExactAssetImage('assets/img/Mask (3).png');
const ExactAssetImage mask4 = ExactAssetImage('assets/img/Mask (4).png');
const ExactAssetImage drawerBg = ExactAssetImage('assets/img/drawerBg.png');
const ExactAssetImage edit = ExactAssetImage('assets/img/edit.png');
const ExactAssetImage demoProduct = ExactAssetImage('assets/img/product.png');
const ExactAssetImage clockLottie = ExactAssetImage('assets/img/89550-clock-timer');

// HomeItem(imgMask: ''),
//   HomeItem(imgMask: 'assets/img/Mask (1).png'),
//   HomeItem(imgMask: 'assets/img/Mask (2).png'),
//   HomeItem(imgMask: 'assets/img/Mask (3).png'),
//   HomeItem(imgMask: 'assets/img/Mask (4).png'),
//   HomeItem(imgMask: 'assets/img/Mask.png'),
//   HomeItem(imgMask: 'assets/img/Mask (1).png'),
//   HomeItem(imgMask: 'assets/img/Mask (2).png'),
//   HomeItem(imgMask: 'assets/img/Mask (3).png'),
//   HomeItem(imgMask: 'assets/img/Mask (4).png'),

class CommonListItem {
  dynamic img;
  String? name;
  String? items;
  CommonListItem({this.img, this.name, this.items});
}

List<CommonListItem> categoriesList = [
  CommonListItem(img: chairImg, name: chair, items: '1065 items'),
  CommonListItem(img: lightImg, name: light, items: '512 items'),
  CommonListItem(img: lampsImg, name: clock, items: '233 items'),
  CommonListItem(img: woodenImg, name: metal, items: '1300 items'),
  CommonListItem(img: chairImg, name: chair, items: '1065 items'),
  CommonListItem(img: lightImg, name: light, items: '512 items'),
  CommonListItem(img: lampsImg, name: clock, items: '233 items'),
  CommonListItem(img: woodenImg, name: metal, items: '1300 items'),
  // {'img': chairImg, 'name': chair, 'items': '1065 items'},
  // {'img': lightImg, 'name': light, 'items': '512 items'},
  // {'img': lampsImg, 'name': clock, 'items': '233 items'},
  // {'img': woodenImg, 'name': metal, 'items': '1300 items'},
  // {'img': chairImg, 'name': chair, 'items': '1065 items'},
  // {'img': lightImg, 'name': light, 'items': '512 items'},
  // {'img': lampsImg, 'name': clock, 'items': '233 items'},
  // {'img': woodenImg, 'name': metal, 'items': '1300 items'},
];

class GridItems {
  final dynamic img;
  final String? name;
  final String? price;

  GridItems({this.img, this.name, this.price});
}

List<GridItems> gridItemList = [
  GridItems(img: mask, name: productDetail, price: '\$9.99'),
  GridItems(img: mask2, name: productDetail, price: '\$9.99'),
  GridItems(img: mask3, name: productDetail, price: '\$9.99'),
  GridItems(img: mask4, name: productDetail, price: '\$9.99'),
  GridItems(img: mask, name: productDetail, price: '\$9.99'),
  GridItems(img: mask2, name: productDetail, price: '\$9.99'),
  GridItems(img: mask3, name: productDetail, price: '\$9.99'),
  GridItems(img: mask4, name: productDetail, price: '\$9.99'),
];

// List<Map<String, dynamic>> arrayList = [
//   {
//     'img': mask,
//     'name': productDetail,
//     'price': '\$9.99',
//   },
//   {
//     'img': mask1,
//     'name': productDetail,
//     'price': '\$9.99',
//   },
//   {
//     'img': mask2,
//     'name': productDetail,
//     'price': '\$9.99',
//   },
//   {
//     'img': mask3,
//     'name': productDetail,
//     'price': '\$9.99',
//   },
//   {
//     'img': mask4,
//     'name': productDetail,
//     'price': '\$9.99',
//   },
// ];
