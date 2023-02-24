part of 'favorite_bloc.dart';

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<Favorites> favorites;

  const FavoriteSuccess(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteFailure extends FavoriteState {
  final String error;

  const FavoriteFailure(this.error);

  @override
  List<Object> get props => [error];
}
