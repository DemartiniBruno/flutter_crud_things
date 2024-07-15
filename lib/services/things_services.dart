import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/things_model.dart';
import 'package:http/http.dart' as http;

  /*
* Get all things
* */
  @override
  Future<List<Thing>> getAllThings() async {
    var url = Uri.parse('http://192.168.3.221:3000/things/');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    final List body = json.decode(response.body);
    return body.map((e) => Thing.fromJson(e)).toList();
  }

/*
* Get one thing
* */
  @override
  Future<Thing> getOneThing(thingId) async{
    var url = Uri.parse('http://192.168.3.221:3000/things/$thingId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    return Thing.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

/*
* Create new thing
* */
  @override
  Future<Thing> createThing(name, value, categoryId) async{
    var url = Uri.parse('http://192.168.3.221:3000/things/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'aproximate_value': value,
        'category_id': categoryId,
      }),
    );
    return Thing.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

/*
* Update tings
* */
  @override
  Future<Thing> updateThing(name, value, categoryId, id) async{
    var url = Uri.parse('http://192.168.3.221:3000/things/$id');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'aproximate_value': value,
        'category_id':categoryId
      }),
    );
    return Thing.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

/*
* Delete thing
* */
  @override
  Future<Thing> deleteThing(id) async{
    var url = Uri.parse('http://192.168.3.221:3000/things/$id');
    final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'}
    );
    return Thing.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
