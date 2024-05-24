import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/common_widgets/custom_alert.dart';
import 'package:news_app/model/top_articles.dart';

class TopArticleApi {
  String apiUrl = '';

  String getApiUrl() {
    return apiUrl =
        "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=NETCnDKeO73LabjwP2EmnpDWN5haK2Gn";
  }

  Future<List<TopArticlesModel>> fetchTopArticls(BuildContext context) async {
    try {
      if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
        final response = await http.get(Uri.parse(apiUrl));
        List<TopArticlesModel> topArticlesList = [];

        if (response.statusCode == 200) {
          List<dynamic> allData = json.decode(response.body)['results'];
          topArticlesList =
              allData.map((e) => TopArticlesModel.fromJson(e)).toList();
        }
        return topArticlesList;
      } else {
        showScaffoldMessenger(context, "No Internet connection!");
      }
      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
