import 'package:flutter_bloc_authentication/models/page.dart';
import 'package:flutter_bloc_authentication/rest/rest.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:injectable/injectable.dart';

const _postLimit = 20;

@singleton
class ProductRepository {
  late RestClient server;
  ProductRepository() {
    server = GetIt.I.get<RestClient>();
  }
  Future<Page> fetchProducts([int startIndex = 0]) async {
    final response = await server.get("/product/search");

    return Page.fromJson(json.decode(response));
  }
}
