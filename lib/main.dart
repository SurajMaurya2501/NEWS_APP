import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/common_widgets/hive_adaptor.dart';
import 'package:news_app/common_widgets/pageroute_builder.dart';
import 'package:news_app/view/article_screen.dart';
import 'package:news_app/view/nav_screen.dart';
import 'package:news_app/view/news.dart';
import 'package:news_app/view/splash_sreen.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ListOfMapsAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/splash",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/splash":
            return CustomPageRouteBuilder(
              page: const SplashScreen(),
            );

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

          case "/nav":
            return CustomPageRouteBuilder(
              page: const NavScreen(),
            );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const SplashScreen(),
    );
  }
}
