import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/Api_Service/category_article_api.dart';
import 'package:news_app/common_widgets/loading_page.dart';
import 'package:news_app/controller/category_controller.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late Future<List<dynamic>> favNews;
  final categoryController =
      CategoryController(categoryArticlesApi: CategoryArticlesApi());

  @override
  void initState() {
    favNews = categoryController.getHiveDataList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: RichText(
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
        body: FutureBuilder<List<dynamic>>(
          future: favNews,
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
              List<dynamic> articles = snapshot.data!;

              return Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    String imgUrl = articles[index]['imageUrl'];
                    String title = articles[index]['title'];
                    String url = articles[index]['url'];
                    return InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, "/article",
                            arguments: {"articleUrl": url});
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
                              width: MediaQuery.of(context).size.width * 0.9,
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
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: const EdgeInsets.all(10.0),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
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
        ));
  }
}
