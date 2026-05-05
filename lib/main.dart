import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'summary.dart';

void main() {
  runApp(const MainApp());
}

class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      "en.wikipedia.org",
      "/api/rest_v1/page/random/summary",
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw const HttpException("Failed to recieve page summary");
    }
    return Summary.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }
}

class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;
  ArticleViewModel(this.model) {
    fetchArticle();
  }

  Future<void> fetchArticle() async {
    isLoading = true;
    notifyListeners();
    try {
      summary = await model.getRandomArticleSummary();
      error = null;
    } on HttpException catch (e) {
      error = e;
      summary = null;
    }
    isLoading = false;
    notifyListeners();
  }
}

class ArticleView extends StatefulWidget {
  ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>{
  final viewModel = ArticleViewModel(ArticleModel());

  @override
  void initState(){
    super.initState();
    viewModel.fetchArticle();
  }

  @override
  Widget build(BuildContext context){
    return Container();
  }
}



class ArticleWidget extends StatelessWidget{
  final Summary summary;
  ArticleWidget ({super.key, required this.summary})

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Column(children: [if(summary.hasImage) Image.network(summary.originalImage!.source),
        Text(summary.titles.normalized),
        Text(summary.description!,
         overflow: TextOverflow.ellipsis,
         style: Theme.of(context).textTheme.displaySmall), 
        if(summary.description!=null) 
        Text(summary.extract)],
      spacing: 10,)
    );
  }
} 


class ArticlePage extends StatelessWidget {
  final Summary summary;
  final VoidCallback next.Article;
  ArticlePage( )
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Wikipedia")),
        body: Center(child: Text('loading...')),
      ),
    );
  }
}
