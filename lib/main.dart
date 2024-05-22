import 'package:flutter/material.dart';
import 'package:news_app/common_widgets/pageroute_builder.dart';
import 'package:news_app/view/article_screen.dart';
import 'package:news_app/view/category_screen.dart';
import 'package:news_app/view/news.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/category":
            return CustomPageRouteBuilder(page: const CategoryNewsScreen());
          case "/article":
            Map<String, dynamic> arguments =
                settings.arguments as Map<String, dynamic>;
            return CustomPageRouteBuilder(
              page: ArticleScreen(
                articleUrl: arguments["articleUrl"],
              ),
            );

          case "/news":
            Map<String, dynamic> arguments =
                settings.arguments as Map<String, dynamic>;
            return CustomPageRouteBuilder(
              page: NewsScreen(
                categoryName: arguments["categoryName"],
              ),
            );
        }
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const CategoryNewsScreen();
  }
}
