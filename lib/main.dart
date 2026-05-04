import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'summary.dart';


void main() {
  runApp(const MainApp());
}

class ArcticleModel {
  Future < Summary > getRandomArticleSummary () async {
    final uri = Uri.https(
      "en.wikipedia.org",
      "/api/rest_v1/page/random/summary"
    );
    final response = await get(uri);

    if (response.statusCode != 200){
      throw const HttpException(
        "Failed to recieve page summary"
      );
    }
    return Summary.fromJson(jsonDecode(response.body) as Map <String, Object?>);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: Scaffold(
        appBar: AppBar(
          title: Text("Wikipedia"), 
        ),
        body:  Center(
          child: Text('loading...'),
        ),
      ),
    );
  }
}

