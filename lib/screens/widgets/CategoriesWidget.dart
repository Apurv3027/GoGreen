import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  List<Map<String, dynamic>> categoriesList = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/categories'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print raw response

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Response Data: $responseData'); // Print parsed response

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('categories')) {
          var categoriesData = responseData['categories'];
          setState(() {
            categoriesList =
                List<Map<String, dynamic>>.from(categoriesData.map((category) {
              return {
                'id': category['id'],
                'name': category['category_name'],
                'img': category['category_image_url'],
              };
            }));
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: categoriesList.isEmpty
          // ? Center(
          //     child: CircularProgressIndicator(),
          //   )
          ? Center(
              child: Text('No categories found'),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 9),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 9.0, vertical: 5),
                        //   child: Image.network(
                        //     categoriesList[index]['img'] ?? defaultURL,
                        //     height: 95,
                        //   ),
                        // ),
                        Container(
                          width: 120, // Fixed width for image
                          height: 150, // Fixed height for image
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Optional: rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(
                                  0,
                                  3,
                                ),
                              ),
                            ],
                          ),
                          child: Image.network(
                            categoriesList[index]['img'] ?? defaultURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          categoriesList[index]['name'],
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
