import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/model/searched_article_model.dart';

class CategoryArticlesApi {
  String apiUrl = '';

  String getApiUrl(String searchTerm) {
    return apiUrl =
        "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=$searchTerm&api-key=NETCnDKeO73LabjwP2EmnpDWN5haK2Gn";
  }

  Future<List<SearchArticleModel>> fetchSearchedArticles() async {
    final response = await http.get(Uri.parse(apiUrl));
    List<SearchArticleModel> categoryArticles = [];

    if (response.statusCode == 200) {
      List<dynamic> allData = json.decode(response.body)['response'];
      categoryArticles =
          allData.map((e) => SearchArticleModel.fromJson(e)).toList();
    }
    return categoryArticles;
  }
}
