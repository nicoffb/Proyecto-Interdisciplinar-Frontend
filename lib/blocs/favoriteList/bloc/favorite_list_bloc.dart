import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_authentication/models/favorites.dart';

import '../../../repositories/favorite_repository.dart';

part 'favorite_list_event.dart';
part 'favorite_list_state.dart';

class FavoriteListBloc {
  final _favoritesController = StreamController<List<Favorites>>.broadcast();
  final FavoriteRepository _favoriteRepository;

  FavoriteListBloc({required FavoriteRepository favoriteRepository})
      : _favoriteRepository = favoriteRepository;

  Stream<List<Favorites>> get favorites => _favoritesController.stream;

  Future<void> getFavorites() async {
    try {
      final favorites = await _favoriteRepository.fetchFavorites();
      _favoritesController.add(favorites);
    } catch (e) {
      debugPrint('Error while fetching favorites: $e');
      _favoritesController.addError(e);
    }
  }

  void dispose() {
    _favoritesController.close();
  }
}
