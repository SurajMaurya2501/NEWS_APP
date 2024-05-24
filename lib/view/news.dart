import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Api_Service/category_article_api.dart';
import 'package:news_app/common_widgets/custom_alert.dart';
import 'package:news_app/common_widgets/loading_page.dart';
import 'package:news_app/controller/category_controller.dart';
import 'package:news_app/model/category_articles.dart';
import 'dart:math';

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
  List<bool> favAdded = [];
  bool isInternetLost = false;
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event.name == "none") {
        showScaffoldMessenger(context, "Lost internet connection!");
        isInternetLost = true;
        setState(() {});
      } else {
        isInternetLost = false;
        categoryNewsArticles = categoryController
            .getCategoryArticle(widget.categoryName, context)
            .whenComplete(() {
          setState(() {});
        });
      }
    });
    categoryNewsArticles =
        categoryController.getCategoryArticle(widget.categoryName, context);
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: isInternetLost
            ? const LoadingPage()
            : RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: () async {
                  var articles = await categoryNewsArticles;
                  setState(() {
                    articles.shuffle(Random());
                    categoryNewsArticles = Future.value(articles);
                  });
                },
                child: FutureBuilder<List<CategoryArticles>>(
                  future: categoryNewsArticles,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingPage();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          "No Data Available",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<CategoryArticles> articles = snapshot.data!;
                      if (favAdded.isEmpty) {
                        favAdded = List.generate(
                          articles.length,
                          (index) => false,
                        );
                      }

                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            String imgUrl =
                                articles[index].multimedia.isNotEmpty
                                    ? articles[index].multimedia[0].url
                                    : '';
                            String articleUrl = articles[index].url;
                            return InkWell(
                              onTap: () async {
                                Navigator.pushNamed(context, "/article",
                                    arguments: {"articleUrl": articleUrl});
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                color: Colors.black,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 180,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        image: imgUrl.isNotEmpty
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  imgUrl,
                                                ),
                                              )
                                            : const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  "assets/images/news.png",
                                                ),
                                              ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Text(
                                            articles[index].title,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            favAdded[index] = !favAdded[index];
                                            categoryController
                                                .storeChatToHive(
                                                    articles[index])
                                                .whenComplete(() {
                                              showScaffoldMessenger(context,
                                                  "News Added To Favourite");
                                            });

                                            setState(() {});
                                          },
                                          icon: Icon(
                                            favAdded[index]
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: favAdded[index]
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No Data Available",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ));
  }
}
