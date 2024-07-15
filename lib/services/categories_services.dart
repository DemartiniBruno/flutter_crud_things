import 'dart:convert';
import '../models/categories_model.dart';
import 'package:http/http.dart' as http;

/*
* Create new category
* */
Future<Category> createCategory(title) async {
  final response = await http.post(
    Uri.parse('http://192.168.3.221:3000/categories/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title
      }),
  );
  return Category.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

/*
* Get all categories
* */
Future<List<Category>> getAllCategories() async {
  var url = Uri.parse('http://192.168.3.221:3000/categories/');
  final response = await http.get(url, headers: {"Content-Type": "application/json"});
  final List body = json.decode(response.body);
  return body.map((e) => Category.fromJson(e)).toList();
}