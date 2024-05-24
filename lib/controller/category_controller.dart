import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/Api_Service/category_article_api.dart';
import 'package:news_app/model/category_articles.dart';

class CategoryController {
  final CategoryArticlesApi categoryArticlesApi;

  CategoryController({required this.categoryArticlesApi});

  List<String> categoryList = [
    'Business',
    'Health',
    'Movies',
    'Politics',
    'Science',
    'Sports',
    'Technology',
    'Travel',
    'World'
  ];

  Future<List<CategoryArticles>> getCategoryArticle(
      String category, BuildContext context) async {
    categoryArticlesApi.getApiUrl(category);
    return await categoryArticlesApi.fetchcategoryNews(context);
  }

  Future storeChatToHive(CategoryArticles articleData) async {
    try {
      String title = articleData.title;
      String imageUrl = articleData.multimedia[0].url;
      String url = articleData.url;
      Map<String, dynamic> mapData = {
        "title": title,
        "imageUrl": imageUrl,
        "url": url
      };
      List<dynamic> dataList = [];
      dataList.add(mapData);
      final hiveBox = await Hive.openBox("fav");

      List<dynamic> hiveDataList = await hiveBox.get("favNews") ?? [];
      List<String> titleList = [];
      hiveDataList.every((element) {
        titleList.add(element['title']);
        return true;
      });
      if (!titleList.contains(mapData['title'])) {
        hiveDataList = hiveDataList + dataList;
        hiveBox.put("favNews", hiveDataList);
      }
    } catch (e) {
      print("Error while Storing chats in hive : $e");
    }
  }

  Future<List<dynamic>> getHiveDataList() async {
    final hiveBox = await Hive.openBox("fav");
    List<dynamic> hiveDataList = hiveBox.get("favNews");
    print('HiveData - $hiveDataList');
    return hiveDataList;
  }
}
