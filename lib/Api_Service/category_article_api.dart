import 'dart:convert';

import 'package:news_app/model/category_articles.dart';
import 'package:http/http.dart' as http;

class CategoryArticlesApi {
  String apiUrl = '';

  String getApiUrl(String category) {
    return apiUrl =
        "https://api.nytimes.com/svc/topstories/v2/$category.json?api-key=NETCnDKeO73LabjwP2EmnpDWN5haK2Gn";
  }

  Future<List<CategoryArticles>> fetchcategoryNews() async {
    final response = await http.get(Uri.parse(apiUrl));
    List<CategoryArticles> categoryArticles = [];

    if (response.statusCode == 200) {
      List<dynamic> allData = json.decode(response.body)['results'];
      print(allData);
      categoryArticles =
          allData.map((e) => CategoryArticles.fromJson(e)).toList();
    }
    return categoryArticles;
  }
}
