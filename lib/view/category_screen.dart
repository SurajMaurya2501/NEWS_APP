import 'package:flutter/material.dart';
import 'package:news_app/Api_Service/category_article_api.dart';
import 'package:news_app/controller/category_controller.dart';

class CategoryNewsScreen extends StatefulWidget {
  const CategoryNewsScreen({super.key});

  @override
  State<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  final CategoryController categoryController =
      CategoryController(categoryArticlesApi: CategoryArticlesApi());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("News Category"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            crossAxisCount: 2,
            childAspectRatio: 2,
          ),
          shrinkWrap: true,
          itemCount: categoryController.categoryList.length,
          itemBuilder: (context, index) {
            String categoryName = categoryController.categoryList[index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/news',
                    arguments: {"categoryName": categoryName.toLowerCase()});
              },
              child: Card(
                elevation: 5.0,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(categoryName),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
