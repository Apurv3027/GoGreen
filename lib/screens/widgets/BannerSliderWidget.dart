import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BannerSliderWidget extends StatefulWidget {
  const BannerSliderWidget({super.key});

  @override
  State<BannerSliderWidget> createState() => _BannerSliderWidgetState();
}

class _BannerSliderWidgetState extends State<BannerSliderWidget> {
  List<Map<String, dynamic>> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/banners'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('banners')) {
          List<dynamic> bannersData = responseData['banners'];
          setState(() {
            _banners = bannersData.map((banner) {
              String imageUrl = banner['banner_image_url'] ?? defaultURL;
              if (imageUrl.startsWith('/')) {
                imageUrl = liveApiDomain + 'storage' +
                    imageUrl;
              }
              return {
                'id': banner['id'].toString(),
                'image': imageUrl,
                'title': banner['banner_name'] ?? 'No Title',
                'description': banner['banner_description'] ?? 'No Description',
              };
            }).toList();
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error fetching banners: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _isLoading
                // ? Center(
                //     child: CircularProgressIndicator(),
                //   )
                ? Center(
                    child: Text('No banners found'),
                  )
                : CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                    items: _banners.map((banner) {
                      return Image.network(
                        banner['image'],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      );
                      // return Stack(
                      //   children: [
                      //     Image.network(
                      //       banner['image'],
                      //       fit: BoxFit.cover,
                      //       width: MediaQuery.of(context).size.width,
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 20.0, right: 100, left: 15),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             banner['title'],
                      //             style: TextStyle(
                      //               color: softWhite,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 22,
                      //             ),
                      //           ),
                      //           SizedBox(height: 8),
                      //           Text(
                      //             banner['description'],
                      //             style: TextStyle(
                      //               color: softWhite,
                      //               fontSize: 18,
                      //             ),
                      //           ),
                      //           SizedBox(height: 35),
                      //           Row(
                      //             children: [
                      //               Text(
                      //                 "Shop",
                      //                 style: TextStyle(
                      //                   decoration: TextDecoration.underline,
                      //                   color: softWhite,
                      //                   fontSize: 18,
                      //                 ),
                      //               ),
                      //               Icon(Icons.skip_next, color: softWhite),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
