import 'package:flutter_bloc_authentication/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:injectable/injectable.dart';

const _postLimit = 20;

@singleton
class PostRepository {
  final httpClient = http.Client();
  final String _baseUrl = 'http://localhost:8080'; // Replace with your URL

  Future<List<Post>> fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        _baseUrl,
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return List<Post>.from(
        body.map((p) => Post.fromJson(p)),
      );
    }
    throw Exception('Error fetching posts');
  }
}
