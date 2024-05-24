import 'package:flutter/material.dart';
import 'package:news_app/view/favourite.dart';
import 'package:news_app/view/news_headline.dart';
import 'package:news_app/view/top_article_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int selectedIndex = 0;
  List<Widget> screens = [
    const TopArticleScreen(),
    const NewsHeadlineScreen(),
    const FavouritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          elevation: 5.0,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          currentIndex: selectedIndex,
          onTap: (value) {
            selectedIndex = value;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.star_border),
                icon: Icon(
                  Icons.star,
                ),
                label: "For You"),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.sunny_snowing),
              icon: Icon(
                Icons.sunny,
              ),
              label: "Headlines",
            ),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.favorite_outline),
                icon: Icon(
                  Icons.favorite,
                ),
                label: "Favourite"),
          ]),
      body: screens[selectedIndex],
    );
  }
}
