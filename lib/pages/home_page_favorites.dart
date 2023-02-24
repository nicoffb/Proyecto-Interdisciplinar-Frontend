import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/authentication/authentication.dart';
import 'package:flutter_bloc_authentication/blocs/favorite/bloc/favorite_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/productList/product_bloc.dart';
import 'package:flutter_bloc_authentication/models/page.dart';
import 'package:flutter_bloc_authentication/pages/pages.dart';
import 'package:flutter_bloc_authentication/pages/product_list.dart';
import 'package:flutter_bloc_authentication/repositories/favorite_repository.dart';
import 'package:flutter_bloc_authentication/repositories/product_repository.dart';
import 'package:flutter_bloc_authentication/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';

import '../models/models.dart';

class FavoritesPage extends StatelessWidget {
  final FavoriteRepository favoriteRepository;

  const FavoritesPage({Key? key, required this.favoriteRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesStream = favoriteRepository.favoritesStream;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: StreamBuilder<List<String>>(
        // final favoritesStream = favoriteRepository.favoritesStream.map((favoritesList) => favoritesList.cast<dynamic>());
        //stream: favoritesStream,

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final favoriteProducts = snapshot.data!;
            if (favoriteProducts.isEmpty) {
              return Center(
                child: Text('No favorite products yet!'),
              );
            }
            final favoritesStream = favoriteRepository.favoritesStream;
            return ProductList(
              stream: favoritesStream,
              isFavoriteList: true,
            );
            ;
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading favorites'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final User user;
  final ProductRepository productRepository;
  final FavoriteRepository favoriteRepository;

  const HomePage({
    Key? key,
    required this.user,
    required this.productRepository,
    required this.favoriteRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FavoritesPage(
                    favoriteRepository: favoriteRepository,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome, ${user.fullName}!',
            style: TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ProductList(
              stream: productRepository.fetchProductsStream(),
              isFavoriteList: false,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Indica el índice de la pestaña actual
        onTap: (index) {
          // Maneja el evento de toque de la pestaña
          if (index == 0) {
            // Navegar a la página de inicio
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/favorites');
          } else if (index == 2) {
            // Realizar el logout
            authBloc.add(UserLoggedOut());
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
