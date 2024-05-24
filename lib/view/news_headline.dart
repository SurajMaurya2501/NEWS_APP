import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/Api_Service/category_article_api.dart';
import 'package:news_app/controller/category_controller.dart';
import 'package:news_app/view/news.dart';

class NewsHeadlineScreen extends StatefulWidget {
  const NewsHeadlineScreen({super.key});

  @override
  State<NewsHeadlineScreen> createState() => _NewsHeadlineScreenState();
}

class _NewsHeadlineScreenState extends State<NewsHeadlineScreen>
    with TickerProviderStateMixin {
  Widget selectedScreen = Container();

  final categoryController =
      CategoryController(categoryArticlesApi: CategoryArticlesApi());
  int selectedIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
        length: categoryController.categoryList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          80,
        ),
        child: AppBar(
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
            backgroundColor: Colors.black,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(
                  50,
                ),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelPadding: const EdgeInsets.all(10),
                  physics: const NeverScrollableScrollPhysics(),
                  onTap: (value) {
                    selectedIndex = value;
                  },
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: categoryController.categoryList
                      .map(
                        (e) => Text(
                          e,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                      .toList(),
                ))),
      ),
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: categoryController.categoryList
            .map(
              (category) => NewsScreen(
                categoryName: category.toLowerCase(),
              ),
            )
            .toList(),
      ),
    );
  }
}
