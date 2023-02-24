part of 'favorite_list_bloc.dart';

abstract class FavoriteListState extends Equatable {
  const FavoriteListState();
  
  @override
  List<Object> get props => [];
}

class FavoriteListInitial extends FavoriteListState {}
