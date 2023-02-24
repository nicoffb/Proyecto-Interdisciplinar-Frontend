import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/authentication/authentication.dart';
import 'package:flutter_bloc_authentication/blocs/favorite/bloc/favorite_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/productList/product_bloc.dart';
import 'package:flutter_bloc_authentication/models/page.dart';
import 'package:flutter_bloc_authentication/pages/product_list.dart';
import 'package:flutter_bloc_authentication/repositories/favorite_repository.dart';
import 'package:flutter_bloc_authentication/repositories/product_repository.dart';
import 'package:get_it/get_it.dart';

import '../models/models.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productRepository = GetIt.I.get<ProductRepository>();
    final favoriteRepository = GetIt.I.get<FavoriteRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              final favoritesStream = favoriteRepository.favoritesStream;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductList(
                    stream: favoritesStream,
                    isFavoriteList: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ProductList(
        stream: productRepository.fetchProductsStream(),
        isFavoriteList: false,
      ),
    );
  }
}
