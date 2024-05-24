import 'package:news_app/Api_Service/search_articles_api.dart';
import 'package:news_app/model/searched_article_model.dart';

class SearchArticleController {
  final SearchArticleApi searchArticlesApi;

  SearchArticleController({required this.searchArticlesApi});


  Future<List<SearchArticleModel>> getSearchedArticle(String searchedTerm) async {
    searchArticlesApi.getApiUrl(searchedTerm);
    return await searchArticlesApi.fetchSearchedArticles();
  }
}
