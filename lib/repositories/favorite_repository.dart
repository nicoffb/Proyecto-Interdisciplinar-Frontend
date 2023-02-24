import 'package:flutter_bloc_authentication/models/favorites.dart';
import 'package:flutter_bloc_authentication/rest/rest.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';

import 'package:injectable/injectable.dart';

@singleton
class FavoriteRepository {
  late RestClient server;

  FavoriteRepository() {
    server = GetIt.I.get<RestClient>();
  }

  Future<List<Favorites>> fetchFavorites() async {
    final response = await server.get("/favorites");
    final List<dynamic> favoritesJson = json.decode(response);

    return favoritesJson.map((json) => Favorites.fromJson(json)).toList();
  }
}
