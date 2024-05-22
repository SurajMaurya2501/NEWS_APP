import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/Api_Service/category_article_api.dart';
import 'package:news_app/common_widgets/loading_page.dart';
import 'package:news_app/controller/category_controller.dart';
import 'package:news_app/model/category_articles.dart';

class NewsScreen extends StatefulWidget {
  final String categoryName;
  const NewsScreen({super.key, required this.categoryName});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<CategoryArticles>> categoryNewsArticles;
  final CategoryController categoryController =
      CategoryController(categoryArticlesApi: CategoryArticlesApi());

  @override
  void initState() {
    categoryNewsArticles =
        categoryController.getCategoryArticle(widget.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<CategoryArticles>>(
      future: categoryNewsArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error Occured"),
          );
        } else if (snapshot.hasData) {
          List<CategoryArticles> articles = snapshot.data!;
          return Container(
            margin: const EdgeInsets.all(5.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                String imgUrl = articles[index].multimedia[0].url;
                String articleUrl = articles[index].url;
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/article",
                        arguments: {"articleUrl": articleUrl});
                  },
                  child: Card(
                    elevation: 10.0,
                    child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    imgUrl,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  articles[index].title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("No Data Available"),
          );
        }
      },
    ));
  }
}
