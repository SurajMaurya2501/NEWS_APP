import 'package:news_app/Api_Service/category_article_api.dart';
import 'package:news_app/model/category_articles.dart';

class CategoryController {
  final CategoryArticlesApi categoryArticlesApi;

  CategoryController({required this.categoryArticlesApi});

  List<String> categoryList = [
    'Arts',
    'Automobiles',
    'Books',
    'Review',
    'Business',
    'Fashion',
    'Food',
    'Health',
    'Home',
    'Insider',
    'Magazine',
    'Movies',
    'Nyregion',
    'Obituaries',
    'Opinion',
    'Politics',
    'Realestate',
    'Science',
    'Sports',
    'Sundayreview',
    'Technology',
    'Theater',
    'T-magazine',
    'Travel',
    'Upshot',
    'Us',
    'World'
  ];

  Future<List<CategoryArticles>> getCategoryArticle(String category) async {
    try {
      categoryArticlesApi.getApiUrl(category);
      return categoryArticlesApi.fetchcategoryNews();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
