import 'package:flutter_bloc_authentication/models/page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:injectable/injectable.dart';

const _postLimit = 20;

@singleton
class ProductRepository {
  final httpClient = http.Client();
  final String _baseUrl = 'http://localhost:8080'; // Replace with your URL

  Future<List<Product>> fetchProducts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        _baseUrl,
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return List<Product>.from(
        body.map((p) => Product.fromJson(p)),
      );
    }
    throw Exception('Error fetching posts');
  }
}
