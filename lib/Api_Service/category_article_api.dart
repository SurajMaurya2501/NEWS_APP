import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:news_app/common_widgets/custom_alert.dart';
import 'package:news_app/model/category_articles.dart';
import 'package:http/http.dart' as http;

class CategoryArticlesApi {
  String apiUrl = '';

  String getApiUrl(String category) {
    return apiUrl =
        "https://api.nytimes.com/svc/topstories/v2/$category.json?api-key=NETCnDKeO73LabjwP2EmnpDWN5haK2Gn";
  }

  Future<List<CategoryArticles>> fetchcategoryNews(BuildContext context) async {
    try {
      if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
        final response = await http.get(Uri.parse(apiUrl));
        List<CategoryArticles> categoryArticles = [];

        if (response.statusCode == 200) {
          List<dynamic> allData = json.decode(response.body)['results'];
          categoryArticles =
              allData.map((e) => CategoryArticles.fromJson(e)).toList();
          return categoryArticles;
        }
      } else {
        showScaffoldMessenger(context, "No Internet Connection");
      }
      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
