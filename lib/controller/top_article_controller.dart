import 'package:flutter/material.dart';
import 'package:news_app/Api_Service/top_article_api.dart';
import 'package:news_app/model/top_articles.dart';

class TopArticleController {
  final TopArticleApi topArticlesApi;

  TopArticleController({required this.topArticlesApi});

  Future<List<TopArticlesModel>> getTopArticles(BuildContext context) async {
    topArticlesApi.getApiUrl();
    return await topArticlesApi.fetchTopArticls(context);
  }
}
