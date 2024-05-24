import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/Api_Service/search_articles_api.dart';
import 'package:news_app/Api_Service/top_article_api.dart';
import 'package:news_app/common_widgets/custom_alert.dart';
import 'package:news_app/controller/search_article_controller.dart';
import 'package:news_app/controller/top_article_controller.dart';
import 'package:news_app/model/searched_article_model.dart';
import 'package:news_app/model/top_articles.dart';

class TopArticleScreen extends StatefulWidget {
  const TopArticleScreen({super.key});

  @override
  State<TopArticleScreen> createState() => _TopArticleScreenState();
}

class _TopArticleScreenState extends State<TopArticleScreen> {
  bool showSearcherArticles = false;
  Future<List<TopArticlesModel>> topArticles = Future.value([]);
  final topArticleController =
      TopArticleController(topArticlesApi: TopArticleApi());
  final _controller = TextEditingController();
  bool isLoading = true;
  late Future<List<SearchArticleModel>> searchedArticles;
  final searchArticleController =
      SearchArticleController(searchArticlesApi: SearchArticleApi());
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event.name == "none") {
        showScaffoldMessenger(context, "Lost internet connection!");
        isLoading = true;
        setState(() {});
      } else {
        topArticles =
            topArticleController.getTopArticles(context).whenComplete(() {
          isLoading = false;
          setState(() {});
        });
      }
    });
    topArticles = topArticleController.getTopArticles(context).whenComplete(() {
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 0,
                  margin: const EdgeInsets.all(
                    5.0,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Lottie.asset(
                            "assets/lottie/logo.json",
                            height: 50,
                          ),
                        ),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Text(
                            "The Modern India",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ]),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20.0,
              ),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Top Stories",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 15.0,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: _controller,
                onSubmitted: (value) {
                  if (_controller.text.isEmpty) {
                    showSearcherArticles = false;
                    setState(() {});
                  } else {
                    isLoading = true;
                    setState(() {});
                    searchedArticles = searchArticleController
                        .getSearchedArticle(value)
                        .whenComplete(() {
                      setState(() {
                        isLoading = false;

                        showSearcherArticles = true;
                      });
                    });
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.newspaper,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_controller.text.isEmpty) {
                          showSearcherArticles = false;
                          setState(() {});
                        } else {
                          isLoading = true;
                          setState(() {});
                          searchedArticles = searchArticleController
                              .getSearchedArticle(_controller.text)
                              .whenComplete(() {
                            setState(() {
                              isLoading = false;

                              showSearcherArticles = true;
                            });
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
                    hintText: "Search News Here...",
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    )),
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {
                switch (showSearcherArticles) {
                  case true:
                    var articles = await searchedArticles;
                    setState(() {
                      articles.shuffle(Random());
                      searchedArticles = Future.value(articles);
                    });
                    break;
                  case false:
                    var articles = await topArticles;
                    setState(() {
                      articles.shuffle(Random());
                      topArticles = Future.value(articles);
                    });
                    break;
                }
              },
              child: isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Lottie.asset('assets/lottie/loading.json',
                          height: 100, width: 100),
                    )
                  : showSearcherArticles
                      ? Container(
                          color: Colors.black,
                          child: FutureBuilder<List<SearchArticleModel>>(
                            future: searchedArticles,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Lottie.asset(
                                      'assets/lottie/loading.json',
                                      height: 100,
                                      width: 100),
                                );
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
                                List<SearchArticleModel> articles =
                                    snapshot.data!;
                                return Container(
                                  color: Colors.black,
                                  margin: const EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.73,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      String imgUrl = articles[index]
                                              .multimedia
                                              .isNotEmpty
                                          ? articles[index].multimedia[0].url
                                          : '';
                                      String articleUrl =
                                          articles[index].web_url;
                                      return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/article", arguments: {
                                            "articleUrl": articleUrl
                                          });
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          color: Colors.black,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    articles[index].headline,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 80,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10.0,
                                                    ),
                                                    image: imgUrl.isNotEmpty
                                                        ? DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              'https://www.nytimes.com/$imgUrl',
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
                                              ),
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
                        )
                      : FutureBuilder<List<TopArticlesModel>>(
                          future: topArticles,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Lottie.asset(
                                    'assets/lottie/loading.json',
                                    height: 100,
                                    width: 100),
                              );
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
                              List<TopArticlesModel> articles = snapshot.data!;
                              return Container(
                                color: Colors.black,
                                margin: const EdgeInsets.only(
                                  top: 5.0,
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.73,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: articles.length,
                                  itemBuilder: (context, index) {
                                    String imgUrl =
                                        articles[index].media.isNotEmpty
                                            ? articles[index].media[0].url
                                            : '';
                                    String articleUrl = articles[index].url;
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, "/article",
                                            arguments: {
                                              "articleUrl": articleUrl
                                            });
                                      },
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        color: Colors.black,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  articles[index].title,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 80,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                            ),
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
            ),
          ],
        ),
      )),
    );
  }
}
