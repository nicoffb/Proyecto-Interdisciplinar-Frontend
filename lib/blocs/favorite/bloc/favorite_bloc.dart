import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc_authentication/models/favorites.dart';
import 'package:flutter_bloc_authentication/repositories/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;

  FavoriteBloc({required this.favoriteRepository}) : super(FavoriteInitial());

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteToggled) {
      if (state is FavoriteInitial) {
        yield FavoriteLoading();
      }
      try {
        final favorites = await favoriteRepository.fetchFavorites();
        yield FavoriteSuccess(favorites);
      } catch (error) {
        yield FavoriteFailure(error.toString());
      }
    }
  }
}
